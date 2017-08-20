@testset "Show methods" begin
  @testset "SimulationProblem" begin
    grid2D = RegularGrid{Float64}(100,200)
    problem = SimulationProblem(data2D, grid2D, :value, 100)
    @test sprint(show, problem) == "2D SimulationProblem (conditional)"
    @test sprint(show, MIME"text/plain"(), problem) == "2D SimulationProblem (conditional)\n  data:      3×3 GeoDataFrame (x and y)\n  domain:    100×200 RegularGrid{Float64,2}\n  variables: value\n  N° reals:  100"
  end
end
