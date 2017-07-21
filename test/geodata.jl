@testset "GeoData" begin
  fname = joinpath(datadir,"data3D.tsv")
  geodata = GeoStats.readtable(fname)
  @test GeoStats.names(geodata) == [:x,:y,:z,:value]
  @test_throws AssertionError GeoStats.readtable(fname, coordnames=[:a])
end
