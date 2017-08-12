@testset "Spatial data" begin
  @test names(data(data3D)) == [:x,:y,:z,:value]
  @test coordnames(data3D) == [:x,:y,:z]
  @test names(coordinates(data3D)) == coordnames(data3D)
  @test npoints(data3D) == 100
  @test_throws AssertionError readtable(fname, coordnames=[:a])
end
