@testset "Utilities" begin
  # pairwise metric function
  P = GeoStats.pairwise((x,y) -> sum(x+y), eye(10))
  @test all(P .== 2)

  # multinomial expansion
  @test GeoStats.multinom_exp(3,2) == [2  0  0
                                       1  1  0
                                       1  0  1
                                       0  2  0
                                       0  1  1
                                       0  0  2]
end
