# Writing solvers

Below are examples of solvers written with the framework.

## Estimation solver example

An estimation solver that, for each location of the domain, assigns the
2-norm of the coordinates as the mean and the ∞-norm as the variance.

```@example normsolver
using GeoStatsBase
using GeoStatsDevTools
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

    for location in SimplePath(pdomain)
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

## Simulation solver example

TODO
