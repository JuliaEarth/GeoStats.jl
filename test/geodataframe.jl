@testset "Spatial data" begin
  fname = joinpath(datadir,"data3D.tsv")
  geodata = readtable(fname)
  @test names(data(geodata)) == [:x,:y,:z,:value]
  @test coordnames(geodata) == [:x,:y,:z]
  @test_throws AssertionError readtable(fname, coordnames=[:a])
end
