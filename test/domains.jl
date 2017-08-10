@testset "Spatial domains" begin
  grid1 = RegularGrid{Float32}(200,100)
  @test ndims(grid1) == 2
  @test coordtype(grid1) == Float32
  @test size(grid1) == (200,100)
  @test npoints(grid1) == 200*100

  grid2 = RegularGrid([200,100,50], zeros(3), ones(3))
  @test ndims(grid2) == 3
  @test coordtype(grid2) == Float64
  @test size(grid2) == (200,100,50)
  @test npoints(grid2) == 200*100*50
end
