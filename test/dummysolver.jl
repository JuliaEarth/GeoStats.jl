import GeoStatsBase: solve_single

# define a dummy solver for testing
@simsolver Dummy begin end
function solve_single(problem::SimulationProblem, var::Symbol,
                      solver::Dummy, preproc)
  pdomain = domain(problem)
  npts = npoints(pdomain)
  V = variables(problem)[var]
  vcat(fill(zero(V), npts÷2), fill(one(V), npts÷2))
end
