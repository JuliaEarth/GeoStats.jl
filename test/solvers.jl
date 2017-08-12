@testset "Geostatistical solvers" begin
  grid = RegularGrid{Float64}(100,100)
  problem = EstimationProblem(data2D, grid, :value)
  solution = solve(problem, Kriging())

  # TODO: test solution correctness
end
