@testset "Utilities" begin
  # pairwise metric function
  P = GeoStats.pairwise((x,y) -> sum(x+y), eye(10))
  @test all(P .== 2)
end
