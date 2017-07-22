@testset "Spatial data" begin
  fname = joinpath(datadir,"data3D.tsv")
  geodata = readtable(fname)
  @test names(geodata) == [:x,:y,:z,:value]
  @test_throws AssertionError readtable(fname, coordnames=[:a])
end
