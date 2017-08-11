@testset "Geostatistical problems" begin
  grid3D = RegularGrid{Float64}(100,100,100)
  problem = EstimationProblem(data3D, grid3D, [:value])
  @test data(problem) == data3D
  @test domain(problem) == grid3D
  @test variables(problem) == [:value]

  grid2D = RegularGrid{Float64}(100,100)
  @test_throws AssertionError EstimationProblem(data3D, grid2D, [:value])
end
