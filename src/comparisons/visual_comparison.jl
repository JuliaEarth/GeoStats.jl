# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    VisualComparison([plot options])

Compare solvers by plotting the results side by side.

## Examples

```julia
julia> compare([solver₁, solver₂], problem, VisualComparison())
```
"""
struct VisualComparison <: AbstractSolverComparison
  plotspecs
end

VisualComparison(; plotspecs...) = VisualComparison(plotspecs)

function compare(solvers::AbstractVector{S}, problem::AbstractProblem,
                 cmp::VisualComparison) where {S<:AbstractSolver}

  # check if Plots.jl is loaded
  isdefined(Main, :Plots) || error("Please load Plots.jl for visual comparison")

  if nworkers() > 1
    # run solvers in parallel
    λ = solver -> solve(problem, solver)
    solutions = pmap(λ, solvers)
  else
    # fallback to serial execution
    solutions = [solve(problem, solver) for solver in solvers]
  end

  # TODO: pass plot specs to recipe
  plts = [RecipesBase.plot(solution) for solution in solutions]

  RecipesBase.plot(plts..., layout=(length(solvers),1))
end
