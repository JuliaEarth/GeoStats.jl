# ------------------------------------------------------------------
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
julia> fsolver  = ImgQuilt(:facies => (TI=Strebelle, template=(30,30,1)))
julia> psolver₀ = DirectGaussSim(:property => (variogram=SphericalVariogram(range=10.),))
julia> psolver₁ = DirectGaussSim(:property => (variogram=SphericalVariogram(range=20.),))
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
  pvars   = variables(problem)
  preals  = nreals(problem)
  pmaps   = datamap(problem)

  # master variable
  mvars = collect(keys(solver.master.params))
  @assert length(mvars) == 1 "one single variable must be specified in master solver"
  mvar = mvars[1]
  @assert mvar ∈ keys(pvars) "invalid variable in master solver"
  mtype = pvars[mvar]

  # other variables
  ovars = Dict(var => V for (var, V) in pvars if var ≠ mvar)
  @assert length(ovars) > 0 "cookie-cutter requires problem with more than one target variable"

  # copy mappings for master variable
  mmapper = CopyMapper(collect(values(pmaps[mvar])), collect(keys(pmaps[mvar])))

  # define master problem
  if hasdata(problem)
    mproblem = SimulationProblem(pdata, pdomain, mvar, preals, mapper=mmapper)
  else
    mproblem = SimulationProblem(pdomain, mvar => mtype, preals, mapper=mmapper)
  end

  # solve master problem
  msolution = solve(mproblem, solver.master)

  # pre-allocate memory for result
  realizations = msolution.realizations
  for (var, V) in ovars
    reals = map(1:preals) do i
      # find inactive locations in master variable
      inactive = findall(isnan, realizations[mvar][i])

      # copy inactive locations to other variable
      real = Vector{V}(undef, npoints(pdomain))
      view(real, inactive) .= V(NaN)

      real
    end
    realizations[var] = reals
  end

  # find mappings for all other variables
  omaps = merge([pmaps[var] for var in keys(ovars)]...)

  # solve other problems
  for (i, mreal) in enumerate(realizations[mvar])
    for (mval, osolver) in solver.others
      # lookup indices with given master value
      inds = findall(isequal(mval), mreal)

      if !isempty(inds)
        # define subdomain
        odomain = view(pdomain, inds)

        # find mappings for subdomain
        datlocs = Vector{Int}()
        domlocs = Vector{Int}()
        for (j, ind) in enumerate(inds)
          if ind ∈ keys(omaps)
            push!(datlocs, omaps[ind])
            push!(domlocs, j)
          end
        end

        # copy hard data if needed
        omapper = CopyMapper(datlocs, domlocs)

        # define subproblem
        if hasdata(problem)
          oproblem = SimulationProblem(pdata, odomain, collect(keys(ovars)), 1, mapper=omapper)
        else
          oproblem = SimulationProblem(odomain, ovars, 1, mapper=omapper)
        end

        # solve subproblem
        osolution = solve(oproblem, osolver)

        # save result and continue
        for (var, V) in ovars
          view(realizations[var][i], inds) .= osolution.realizations[var][1]
        end
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
  mvar = collect(keys(solver.master.params))[1]
  println(io, solver)
  println(io, "  └─", mvar, " ⇨ ", solver.master)
  for (val, osolver) in solver.others
    println(io, "    └─", val, " ⇨ ", osolver)
  end
end
