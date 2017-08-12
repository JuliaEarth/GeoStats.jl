@testset "Show methods" begin
  @testset "GeoDataFrame" begin
    rawdata = DataFrames.DataFrame(x=[1,2,3],y=[4,5,6])
    geodata = GeoDataFrame(rawdata, [:x,:y])
    @test sprint(show, geodata) == "3×2 GeoDataFrame (x and y)"
    @test sprint(show, MIME"text/plain"(), geodata) == "3×2 GeoDataFrame (x and y)\n│ Row │ x │ y │\n├─────┼───┼───┤\n│ 1   │ 1 │ 4 │\n│ 2   │ 2 │ 5 │\n│ 3   │ 3 │ 6 │"
    @test sprint(show, MIME"text/html"(), geodata) == "3×2 GeoDataFrame (x and y)\n<table class=\"data-frame\"><thead><tr><th></th><th>x</th><th>y</th></tr></thead><tbody><tr><th>1</th><td>1</td><td>4</td></tr><tr><th>2</th><td>2</td><td>5</td></tr><tr><th>3</th><td>3</td><td>6</td></tr></tbody></table>"
  end

  @testset "RegularGrid" begin
    grid = RegularGrid{Float64}(100,200)
    @test sprint(show, grid) == "100×200 RegularGrid{Float64,2}"
    @test sprint(show, MIME"text/plain"(), grid) == "RegularGrid{Float64,2}\n  dimensions: (100, 200)\n  origin:     (0.0, 0.0)\n  spacing:    (1.0, 1.0)"
  end

  @testset "EstimationProblem" begin
    grid2D = RegularGrid{Float64}(100,200)
    problem = EstimationProblem(data2D, grid2D, [:value])
    @test sprint(show, problem) == "2D EstimationProblem"
    @test sprint(show, MIME"text/plain"(), problem) == "2D EstimationProblem\n  data:      3×3 GeoDataFrame (x and y)\n  domain:    100×200 RegularGrid{Float64,2}\n  variables: value"
  end
end
