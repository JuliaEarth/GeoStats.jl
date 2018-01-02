@testset "Problems" begin
  grid2D = RegularGrid{Float64}(100,100)
  grid3D = RegularGrid{Float64}(100,100,100)

  @testset "Estimation" begin
    problem = EstimationProblem(data3D, grid3D, :value)
    @test data(problem) == data3D
    @test domain(problem) == grid3D
    @test variables(problem) == Dict(:value => Float64)
    @test_throws AssertionError EstimationProblem(data3D, grid2D, :value)

    # show methods
    grid2D = RegularGrid{Float64}(100,200)
    problem = EstimationProblem(data2D, grid2D, :value)
    @test sprint(show, problem) == "2D EstimationProblem"
    @test sprint(show, MIME"text/plain"(), problem) == "2D EstimationProblem\n  data:      3×3 GeoDataFrame (x and y)\n  domain:    100×200 RegularGrid{Float64,2}\n  variables: value (Float64)"
  end

  @testset "Simulation" begin
    problem = SimulationProblem(data3D, grid3D, :value, 100)
    @test data(problem) == data3D
    @test domain(problem) == grid3D
    @test variables(problem) == Dict(:value => Float64)
    @test hasdata(problem)
    @test nreals(problem) == 100
    @test_throws AssertionError SimulationProblem(data3D, grid2D, :value, 100)

    # show methods
    grid2D = RegularGrid{Float64}(100,200)
    problem = SimulationProblem(data2D, grid2D, :value, 100)
    @test sprint(show, problem) == "2D SimulationProblem (conditional)"
    @test sprint(show, MIME"text/plain"(), problem) == "2D SimulationProblem (conditional)\n  data:      3×3 GeoDataFrame (x and y)\n  domain:    100×200 RegularGrid{Float64,2}\n  variables: value (Float64)\n  N° reals:  100"
  end
end
