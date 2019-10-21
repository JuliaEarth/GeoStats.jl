# Developer guide

This guide provides an overview of the spatial problems and solution types
defined in the framework. After reading this document, you should be able
to write your own geostatistical solvers, and enjoy a large set of features
*for free*, including distributed parallel execution, a suite of meta
algorithms, and various plot recipes. If you have any questions, please
don't hesitate to ask in our
[gitter channel](https://gitter.im/JuliaEarth/GeoStats.jl).

## The basics

Currently, there are three types of spatial problems defined in the framework:

```julia
EstimationProblem
SimulationProblem
LearningProblem
```

For each problem type, there is a corresponding solution type:

```julia
EstimationSolution
SimulationSolution
LearningSolution
```

Any `EstimationSolver` in the framework returns an `EstimationSolution`, which
consists of the domain of the `EstimationProblem` plus two dictionaries: `mdict`
mapping the variable names (a `Symbol`) of the problem to mean values, and `vdict`
mapping the same variable names to variance values:

```julia
EstimationSolution(domain, mdict, vdict)
```

Any `SimulationSolver` in the framework returns a `SimulationSolution`, which
consists of the domain of the `SimulationProblem` plus a dictionary `rdict`
mapping the variable names (a `Symbol`) of the problem to a vector of (flattened)
realizations:

```julia
SimulationSolution(domain, rdict)
```

Any `LearningSolver` in the framework returns a `LearningSolution`, which consits
of the target domain of the `LearningProblem` plus a dictionary `dict` mapping
variable names (a `Symbol`) of the problem to learned values:

```julia
LearningSolution(domain, dict)
```

These definitions are implemented in the
[GeoStatsBase.jl](https://github.com/juliohm/GeoStatsBase.jl)
package alongside other important conceptual
components of the project.

### Writing a solver

The task of writing a solver for a spatial problem as defined consists of
writing a simple function in Julia that takes the problem as input and returns
the solution. In this section, an estimation solver is written that is not very
useful (it fills the domain with random numbers), but that illustrates the
development process.

#### Create the package

Install the `PkgTemplates.jl` package and create a new project:

```julia
using PkgTemplates

generate_interactive("MySolver")
```

This command will create a folder named `~/user/.julia/vx.y/MySolver` with all
the files that are necessary to load the new package:

```julia
using MySolver
```

Choose a license for your solver. If you don't have major restrictions, I suggest
using the `ISC` license. This license is equivalent to the `MIT` and `BSD 2-Clause`
licenses, plus it eliminates [unncessary language](https://en.wikipedia.org/wiki/ISC_license).
Try to choose a [permissive license](https://opensource.org/licenses) so that your
solver can be used, and improved by private companies.

#### Import GeoStatsBase

After the package is created, open the main source file `MySolver.jl` and add the
following line:

```julia
using GeoStatsBase
import GeoStatsBase: solve
```

These lines bring all the symbols defined in `GeoStatsBase` into scope, and tell
Julia that the method `solve` will be specialized for the new solver. Next, give
your solver a name:

```julia
struct MyCoolSolver <: AbstractEstimationSolver
  # optional parameters go here
end
```

and export it so that it becomes available to users of your package:

```julia
export MyCoolSolver
```

At this point, the `MySolver.jl` file should have the following content:

```julia
module MySolver

using GeoStatsBase
import GeoStatsBase: solve

export MyCoolSolver

struct MyCoolSolver <: AbstractEstimationSolver
  # optional parameters go here
end

end # module
```

#### Write the algorithm

Now that your solver type is defined, write your algorithm. Write a function called
`solve` that takes an estimation problem and your solver, and returns an estimation
solution:

```julia
function solve(problem::EstimationProblem, solver::MyCoolSolver)
  pdomain = domain(problem)

  mean = Dict{Symbol,Vector}()
  variance = Dict{Symbol,Vector}()

  for (var,V) in variables(problem)
    push!(mean, var => rand(npoints(pdomain)))
    push!(variance, var => rand(npoints(pdomain)))
  end

  EstimationSolution(pdomain, mean, variance)
end
```

Paste this function somewhere in your package, and you are all set.

#### Test the solver

To test your new solver, load the `GeoStats.jl` package and solve a simple problem:

```julia
using GeoStats
using MySolver

sdata    = readgeotable("somedata.csv", coordnames=[:x,:y])
sdomain  = RegularGrid{Float64}(100, 100)
problem  = EstimationProblem(sdata, sdomain, :value)

solution = solve(problem, MyCoolSolver())

plot(solution)
```

#### Writing simulation solvers

The process of writing a simulation solver is very similar, but there is an alternative
function to `solve` called `solve_single` that is *preferred*. The function `solve_single`
takes a simulation problem, one of the variables to be simulated, a solver, and a
preprocessed input, and returns a *vector* with the simulation results:

```julia
function solve_single(problem::SimulationProblem,
                      var::Symbol, solver::MySimSolver, preproc)
  # retrieve problem info
  pdata = data(problem)
  pdomain = domain(problem)
  V = valuetype(pdata, var)

  # output is a single realization
  realization = Vector{V}(undef, npoints(pdomain))

  # fill realization with hard data
  for (loc, datloc) in datamap(problem, var)
    realization[loc] = value(pdata, datloc, var)
  end

  # algorithm goes here
  # ...

  realization
end
```

This function is preferred over `solve` if your algorithm is the same for every single
realization (the algorithm is only a function of the random seed). In this case, GeoStats.jl
will provide an implementation of `solve` for you that calls `solve_single` in parallel.

The argument `preproc` is ignored unless the function `preprocess` is also defined for the
solver. The function takes a simulation problem and a solver, and returns an arbitrary object
with preprocessed data:

```julia
preprocess(problem::SimulationProblem, solver::MySimSolver) = nothing
```

#### Writing learning solvers

Similar to the other cases, writing a `LearningSolver` compatible with the framework consists
of writing a simple Julia function that takes the `LearningProblem` as input along with the solver,
and returns a `LearningSolution`.

## Solver examples

Below are examples of solvers written with the framework.

### Estimation solver example

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

  for (var,V) in variables(problem)
    # get user parameters
    if var in keys(solver.params)
      varparams = solver.params[var]
    else
      varparams = NormSolverParam()
    end

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

  EstimationSolution(pdomain, Dict(μs), Dict(σs))
end;
```

We can test the newly defined solver on an estimation problem:

```@example normsolver
using GeoStats
using Plots
gr(size=(900,400)) # hide

# dummy spatial data with a single point and no value
sdata   = PointSetData(Dict(:z => [NaN]), reshape([0.,0.], 2, 1))

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
png("images/normsolver2.png") # hide
```
![](images/normsolver2.png)

### Simulation solver example

A simulation solver that, for each location of the domain, assigns a random
sample from a Gaussian distribution.

```@example randsolver
using GeoStatsBase

# implement method for new solver
import GeoStatsBase: solve_single

@simsolver RandSolver begin
  @param mean = 0
  @param var  = 1
end

function solve_single(problem::SimulationProblem, var::Symbol,
                      solver::RandSolver, preproc)
  pdomain = domain(problem)

  # retrieve solver parameters
  varparams = solver.params[var]
  μ, σ² = varparams.mean, varparams.var

  # i.i.d. samples ~ Normal(0,1)
  z = rand(npoints(pdomain))

  # rescale and return
  μ .+ sqrt(σ²) .* z
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
png("images/randsolver1.png") # hide
```
![](images/randsolver1.png)

Note, however, that we did not define the `preprocess` function for the solver.
This function can be used to avoid recalculations for each realization, and to
set default parameters for variables that are not explicitly set by users in the
solver constructor:

```@example randsolver
import GeoStatsBase: preprocess

function preprocess(problem::SimulationProblem, solver::RandSolver)
  # result of preprocessing
  preproc = Dict{Symbol,NamedTuple}()

  for (varname, V) in variables(problem)
    if varname ∈ keys(solver.params)
      # get user parameters
      varparams = solver.params[varname]
    else
      # set default parameters
      varparams = RandSolverParam()
    end

    preproc[varname] = (mean=varparams.mean, var=varparams.var)
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
`solve_single` function, which could be reimplemented as follows:

```@example randsolver
function solve_single(problem::SimulationProblem, var::Symbol,
                      solver::RandSolver, preproc)
  pdomain = domain(problem)

  # retrieve solver parameters
  μ, σ² = preproc[var]

  # i.i.d. samples ~ Normal(0,1)
  z = rand(npoints(pdomain))

  # rescale and return
  μ .+ sqrt(σ²) .* z
end;
```

### Learning solver example

TODO
