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
    AbstractSolver

A solver for geostatistical problems.
"""
abstract type AbstractSolver end

"""
    AbstractEstimationSolver

A solver for a geostatistical estimation problem.
"""
abstract type AbstractEstimationSolver <: AbstractSolver end

"""
    solve(problem, solver)

Solve the estimation `problem` with estimation `solver`.
"""
solve(::EstimationProblem, ::AbstractEstimationSolver) = error("not implemented")

"""
    AbstractSimulationSolver

A solver for a geostatistical simulation problem.
"""
abstract type AbstractSimulationSolver <: AbstractSolver end

"""
    solve(problem, solver)

Solve the simulation `problem` with simulation `solver`.

### Notes

Default implementation calls `solve_single` in parallel.
"""
function solve(problem::SimulationProblem{<:AbstractDomain}, solver::AbstractSimulationSolver)
  # sanity checks
  @assert keys(solver.params) ⊆ variables(problem) "invalid variable names in solver parameters"

  realizations = Dict{Symbol,Vector{Vector}}()
  for var in variables(problem)
      # TODO: run in parallel
      varreals = [solve_single(problem, var, solver) for i=1:nreals(problem)]

      push!(realizations, var => varreals)
  end

  SimulationSolution(domain(problem), realizations)
end

"""
    solve_single(problem, var, solver)

Solve a single realization of `var` in the `problem` with simulation `solver`.

### Notes

In most cases, this is the function that solver writers should write.
By implementing it, the developer is informing the package that realizations
generated with his/her solver are indenpendent one from another. The package
will then automatically trigger the algorithm in parallel at the top-level
`solve` call.
"""
solve_single(::SimulationProblem, ::Symbol, ::AbstractSimulationSolver) = error("not implemented")

#------------------
# IMPLEMENTATIONS
#------------------
include("solvers/kriging_solver.jl")
include("solvers/sgsim_solver.jl")
