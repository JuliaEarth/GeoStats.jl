# Solver examples

Below are examples of solvers written with the framework.

## Estimation

An estimation solver that, for each location of the domain, assigns the
2-norm of the coordinates as the mean and the ∞-norm as the variance.

```@example normsolver
using GeoStatsBase
using LinearAlgebra: norm

# implement method for new solver
import GeoStatsBase: solve

@estimsolver NormSolver begin
  @param pmean = 2
  @param pvar  = Inf
end

function solve(problem::EstimationProblem, solver::NormSolver)
  pdomain = domain(problem)

  # results for each variable
  μs = []; σs = []

  for covars in covariables(problem, solver)
    for var in covars.names
      # get user parameters
      varparams = covars.params[(var,)]

      # get variable type
      V = variables(problem)[var]

      # allocate memory for result
      varμ = Vector{V}(undef, npoints(pdomain))
      varσ = Vector{V}(undef, npoints(pdomain))

      for location in LinearPath(pdomain)
        x = coordinates(pdomain, location)

        varμ[location] = norm(x, varparams.pmean)
        varσ[location] = norm(x, varparams.pvar)
      end

      push!(μs, var => varμ)
      push!(σs, var => varσ)
    end
  end

  EstimationSolution(pdomain, Dict(μs), Dict(σs))
end;
```

We can test the newly defined solver on an estimation problem:

```@example normsolver
using GeoStats
using Plots
gr(size=(900,400)) # hide

# dummy spatial data with a single point and no value
sdata   = PointSetData(OrderedDict(:z => [NaN]), reshape([0.,0.], 2, 1))

# estimate on a regular grid
sdomain = RegularGrid{Float64}(100, 100)

# the problem to be solved
problem = EstimationProblem(sdata, sdomain, :z)

# our new solver
solver = NormSolver()

solution = solve(problem, solver)

contourf(solution)
png("images/normsolver1.png") # hide
```
![](images/normsolver1.png)

And assess the behavior of different parameters:

```@example normsolver
solver = NormSolver(:z => (pmean=1,pvar=3))

solution = solve(problem, solver)

contourf(solution)
savefig("images/normsolver2.svg") # hide
```
![](images/normsolver2.svg)

## Simulation

A simulation solver that, for each location of the domain, assigns a random
sample from a Gaussian distribution.

```@example randsolver
using GeoStatsBase

# implement method for new solver
import GeoStatsBase: solvesingle

@simsolver RandSolver begin
  @param mean = 0
  @param var  = 1
end

function solvesingle(problem::SimulationProblem, covars::NamedTuple,
                     solver::RandSolver, preproc)
  pdomain = domain(problem)

  real4var = map(covars.names) do var
    # retrieve solver parameters
    varparams = covars.params[(var,)]
    μ, σ² = varparams.mean, varparams.var

    # i.i.d. samples ~ Normal(0,1)
    z = rand(npoints(pdomain))

    # rescale and return
    var => μ .+ sqrt(σ²) .* z
  end

  Dict(real4var)
end;
```

We can test the newly defined solver in a simulation problem:

```@example randsolver
using GeoStats
using Plots
gr(size=(900,300)) # hide

# simulate on a regular grid
sdomain = RegularGrid{Float64}(100, 100)

# the problem to be solved
problem = SimulationProblem(sdomain, :z => Float64, 3)

# our new solver
solver = RandSolver(:z => (mean=10.,var=10.))

solution = solve(problem, solver)

heatmap(solution)
savefig("images/randsolver1.svg") # hide
```
![](images/randsolver1.svg)

Note, however, that we did not define the `preprocess` function for the solver.
This function can be used to avoid recalculations for each realization, and to
set default parameters for variables that are not explicitly set by users in the
solver constructor:

```@example randsolver
import GeoStatsBase: preprocess

function preprocess(problem::SimulationProblem, solver::RandSolver)
  preproc = Dict()
  for covars in covariables(problem, solver)
    for varname in covars.names
      varparams = covars.params[(varname,)]
      preproc[varname] = (mean=varparams.mean, var=varparams.var)
    end
  end

  preproc
end;
```

We can call the `preprocess` function on problems with multiple variables
to check that the solver is producing default values for variables other
than the one passed during construction:

```@example randsolver
problem = SimulationProblem(sdomain, (:z=>Float64, :w=>Float64), 3)

preprocess(problem, solver)
```

This `preproc` output is passed by GeoStats.jl as the last argument to the
`solvesingle` function, which could be reimplemented as follows:

```@example randsolver
function solvesingle(problem::SimulationProblem, covars::NamedTuple,
                     solver::RandSolver, preproc)
  pdomain = domain(problem)

  real4var = map(covars.names) do var
    # retrieve solver parameters
    μ, σ² = preproc[var]

    # i.i.d. samples ~ Normal(0,1)
    z = rand(npoints(pdomain))

    # rescale and return
    var => μ .+ sqrt(σ²) .* z
  end

  Dict(real4var)
end;
```

## Learning

A learning solver that clusters data into super pixels:

```@example slicsolver
using GeoStatsBase

# implement method for new solver
import GeoStatsBase: solvesingle

struct SLICSolver <: AbstractLearningSolver
  k::Int # approximate number of super pixels
  m::Float64 # SLIC tradeoff parameter
end

function solve(problem::LearningProblem, solver::SLICSolver)
  @assert task(problem) isa ClusteringTask "invalid problem"

  # retrieve problem info
  ptask  = task(problem)
  feats  = collect(features(ptask))
  tdata  = targetdata(problem)
  output = outputvars(ptask)[1]

  # find super pixels
  slic = SLICPartitioner(solver.k, solver.m, vars=feats)
  part = partition(tdata, slic)

  # label for each point in target data
  labels = Vector{Int}(undef, npoints(tdata))
  for (i, inds) in enumerate(subsets(part))
    labels[inds] .= i
  end

  # return learning solution
  LearningSolution(domain(tdata), OrderedDict(output => labels))
end;
```

We can test the newly defined solver in a learning problem:

```@example slicsolver
using GeoStats
using Plots
gr(size=(900,300)) # hide

Z = [10sin(i/10) + j for i in 1:100, j in 1:100]

Ω = RegularGridData{Float64}(OrderedDict(:Z=>Z))

t = ClusteringTask(:Z, :SUPERPIXEL)

p = LearningProblem(Ω, Ω, t)

s = solve(p, SLICSolver(50, 0.01))

plot(plot(Ω), plot(s, c=:viridis))
savefig("images/slicsolver.svg") # hide
```
![](images/slicsolver.svg)
