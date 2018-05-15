# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    CookieCutter(master, others)

A cookie-cutter simulation solver.

## Parameters

* `master` - Master simulation solver (a.k.a. facies solver)
* `others` - A list of pairs mapping categories to solvers

## Examples

Simulate lithology facies with image quilting and fill property
with direct Gaussian simulation:

```julia
julia> fsolver  = ImgQuilt(:facies => @NT(TI=Strebelle, template=(30,30,1)))
julia> psolver₀ = DirectGaussSim(:property => @NT(variogram=SphericalVariogram(range=10.)))
julia> psolver₁ = DirectGaussSim(:property => @NT(variogram=SphericalVariogram(range=20.)))
julia> solver   = CookieCutter(fsolver, [0 => psolver₀, 1 => psolver₁])
```
"""
struct CookieCutter <: AbstractSimulationSolver
  master::AbstractSimulationSolver
  others::Vector{Pair{Number,AbstractSimulationSolver}}
end

function solve(problem::SimulationProblem, solver::CookieCutter)
  # retrieve problem info
  pdata   = data(problem)
  pdomain = domain(problem)
  pmapper = mapper(problem)
  pvars   = variables(problem)
  preals  = nreals(problem)

  mastervars = collect(keys(solver.master.params))
  @assert length(mastervars) == 1 "only one variable can be specified in master solver"

  mastervar = mastervars[1]
  @assert mastervar ∈ keys(pvars) "invalid variable in master solver"
  mastertype = pvars[mastervar]

  others = Dict(var => V for (var,V) in pvars if var ≠ mastervar)
  @assert length(others) > 0 "cookie-cutter requires problem with more than one target variable"

  # define master and other problems
  if hasdata(problem)
    mproblem = SimulationProblem(pdata, pdomain, mastervar, preals, mapper=pmapper)
    oproblem = SimulationProblem(pdata, pdomain, keys(others), preals, mapper=pmapper)
  else
    mproblem = SimulationProblem(pdomain, mastervar => mastertype, preals, mapper=pmapper)
    oproblem = SimulationProblem(pdomain, others, preals, mapper=pmapper)
  end

  # solve master problem
  msolution = solve(mproblem, solver.master)

  # pre-allocate memory for result
  realizations = msolution.realizations
  for (var, V) in others
    realizations[var] = [Vector{V}(npoints(pdomain)) for i in 1:preals]
  end

  # use master solution as guide
  guides = realizations[mastervar]

  # solve other problems
  for (mval, osolver) in solver.others
    osolution = solve(oproblem, osolver)
    for (var, oreals) in osolution.realizations
      for i in 1:preals
        mask = guides[i] .≈ mval
        realizations[var][i][mask] .= oreals[i][mask]
      end
    end
  end

  SimulationSolution(pdomain, realizations)
end

# ------------
# IO methods
# ------------
function Base.show(io::IO, solver::CookieCutter)
  print(io, "CookieCutter")
end

function Base.show(io::IO, ::MIME"text/plain", solver::CookieCutter)
  mastervar = collect(keys(solver.master.params))[1]
  println(io, solver)
  println(io, "  └─", mastervar, " ⇨ ", solver.master)
  for (val, osolver) in solver.others
    println(io, "    └─", val, " ⇨ ", osolver)
  end
end
