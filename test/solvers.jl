@testset "Geostatistical solvers" begin
  grid = RegularGrid{Float64}(100,100)

  # estimation with Kriging
  problem = EstimationProblem(data2D, grid, :value)
  solution = solve(problem, Kriging())
  # TODO: test solution correctness

  # conditional simulation with SGSim
  problem = SimulationProblem(data2D, grid, :value, 3)
  solution = solve(problem, SGSim())
  # TODO: test solution correctness

  # unconditional simulation with SGSim
  problem = SimulationProblem(grid, :value, 3)
  solution = solve(problem, SGSim())
  # TODO: test solution correctness
end
