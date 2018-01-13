@testset "Data" begin
  # basic checks
  @test coordinates(data3D) == Dict(var => Float64 for var in [:x,:y,:z])
  @test variables(data3D) == Dict(:value => Float64)
  @test npoints(data3D) == 100
  X, z = valid(data3D, :value)
  @test size(X,2) == 100
  @test length(z) == 100
  @test_throws AssertionError readtable(fname3D, delim='\t', coordnames=[:a])

  # missing data and NaN
  X, z = valid(missdata, :value)
  @test size(X) == (2,1)
  @test length(z) == 1

  # show methods
  rawdata = DataFrames.DataFrame(x=[1,2,3],y=[4,5,6])
  geodata = GeoDataFrame(rawdata, [:x,:y])
  @test sprint(show, geodata) == "3×2 GeoDataFrame (x and y)"
  @test sprint(show, MIME"text/plain"(), geodata) == "3×2 GeoDataFrame (x and y)\n\n│ Row │ x │ y │\n├─────┼───┼───┤\n│ 1   │ 1 │ 4 │\n│ 2   │ 2 │ 5 │\n│ 3   │ 3 │ 6 │"
  @test sprint(show, MIME"text/html"(), geodata) == "3×2 GeoDataFrame (x and y)\n<table class=\"data-frame\"><thead><tr><th></th><th>x</th><th>y</th></tr></thead><tbody><tr><th>1</th><td>1</td><td>4</td></tr><tr><th>2</th><td>2</td><td>5</td></tr><tr><th>3</th><td>3</td><td>6</td></tr></tbody></table>"
end
