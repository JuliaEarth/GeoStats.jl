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
    solve(problem, solver)

Solve the simulation `problem` with the simulation `solver`.

### Notes

Default implementation calls `solve_single` in parallel.
"""
function solve(problem::SimulationProblem, solver::AbstractSimulationSolver)
  # sanity checks
  @assert keys(solver.params) ⊆ variables(problem) "invalid variable names in solver parameters"

  realizations = Dict{Symbol,Vector{Vector}}()
  for var in variables(problem)
    if nprocs() > 2
      # generate realizations in parallel
      λ = _ -> solve_single(problem, var, solver)
      varreals = pmap(λ, 1:nreals(problem))
    else
      # fallback to serial execution
      varreals = [solve_single(problem, var, solver) for i=1:nreals(problem)]
    end

    push!(realizations, var => varreals)
  end

  SimulationSolution(domain(problem), realizations)
end

#------------------
# IMPLEMENTATIONS
#------------------
include("solvers/kriging_solver.jl")
include("solvers/sgsim_solver.jl")
