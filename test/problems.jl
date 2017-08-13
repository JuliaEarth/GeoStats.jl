@testset "Geostatistical problems" begin
  grid2D = RegularGrid{Float64}(100,100)
  grid3D = RegularGrid{Float64}(100,100,100)

  for Problem in [EstimationProblem, SimulationProblem]
    problem = Problem(data3D, grid3D, :value)
    @test data(problem) == data3D
    @test domain(problem) == grid3D
    @test variables(problem) == [:value]
    @test hasdata(problem)
    @test_throws AssertionError Problem(data3D, grid2D, :value)
  end
end
