@testset "Spatial domains" begin
  grid1 = RegularGrid{Float64}(200,100)
  grid2 = RegularGrid([200,100,50], zeros(3), ones(3))
  @test dimension(grid1) == 2
  @test dimension(grid2) == 3
end
