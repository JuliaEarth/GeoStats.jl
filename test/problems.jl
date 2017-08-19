@testset "Problems" begin
  grid2D = RegularGrid{Float64}(100,100)
  grid3D = RegularGrid{Float64}(100,100,100)

  @testset "Estimation" begin
    problem = EstimationProblem(data3D, grid3D, :value)
    @test data(problem) == data3D
    @test domain(problem) == grid3D
    @test variables(problem) == [:value]
    @test hasdata(problem)
    @test_throws AssertionError EstimationProblem(data3D, grid2D, :value)
  end

  @testset "Simulation" begin
    problem = SimulationProblem(data3D, grid3D, :value, 100)
    @test data(problem) == data3D
    @test domain(problem) == grid3D
    @test variables(problem) == [:value]
    @test hasdata(problem)
    @test nreals(problem) == 100
    @test_throws AssertionError SimulationProblem(data3D, grid2D, :value, 100)
  end
end
