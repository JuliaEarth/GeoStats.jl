@testset "Data" begin
  @test names(data(data3D)) == [:x,:y,:z,:value]
  @test coordnames(data3D) == [:x,:y,:z]
  @test names(coordinates(data3D)) == coordnames(data3D)
  @test npoints(data3D) == 100
  @test_throws AssertionError readtable(fname, coordnames=[:a])

  # show methods
  rawdata = DataFrames.DataFrame(x=[1,2,3],y=[4,5,6])
  geodata = GeoDataFrame(rawdata, [:x,:y])
  @test sprint(show, geodata) == "3×2 GeoDataFrame (x and y)"
  @test sprint(show, MIME"text/plain"(), geodata) == "3×2 GeoDataFrame (x and y)\n│ Row │ x │ y │\n├─────┼───┼───┤\n│ 1   │ 1 │ 4 │\n│ 2   │ 2 │ 5 │\n│ 3   │ 3 │ 6 │"
  @test sprint(show, MIME"text/html"(), geodata) == "3×2 GeoDataFrame (x and y)\n<table class=\"data-frame\"><thead><tr><th></th><th>x</th><th>y</th></tr></thead><tbody><tr><th>1</th><td>1</td><td>4</td></tr><tr><th>2</th><td>2</td><td>5</td></tr><tr><th>3</th><td>3</td><td>6</td></tr></tbody></table>"
end
