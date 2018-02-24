# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    solve(problem, solver)

Solve the simulation `problem` with the simulation `solver`.

### Notes

Default implementation calls `solve_single` in parallel.
"""
function solve(problem::SimulationProblem, solver::AbstractSimulationSolver)
  # sanity checks
  @assert keys(solver.params) ⊆ keys(variables(problem)) "invalid variable names in solver parameters"

  realizations = []
  for (var,V) in variables(problem)
    if nworkers() > 1
      # generate realizations in parallel
      λ = _ -> solve_single(problem, var, solver)
      varreals = pmap(λ, 1:nreals(problem))
    else
      # fallback to serial execution
      varreals = [solve_single(problem, var, solver) for i=1:nreals(problem)]
    end

    push!(realizations, var => varreals)
  end

  SimulationSolution(domain(problem), Dict(realizations))
end

#------------------
# IMPLEMENTATIONS
#------------------
include("solvers/kriging_solver.jl")
include("solvers/sgsim_solver.jl")
