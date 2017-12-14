## Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
##
## Permission to use, copy, modify, and/or distribute this software for any
## purpose with or without fee is hereby granted, provided that the above
## copyright notice and this permission notice appear in all copies.
##
## THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
## WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
## ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
## WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
## ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
## OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

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

  if nprocs() > 2
    # run solvers in parallel
    λ = solver -> solve(problem, solver)
    solutions = pmap(λ, solvers)
  else
    # fallback to serial execution
    solutions = [solve(problem, solver) for solver in solvers]
  end

  plts = [RecipesBase.plot(solution) for solution in solutions]

  RecipesBase.plot(plts..., layout=(length(solvers),1))
end
