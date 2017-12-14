@testset "Utilities" begin
  # pairwise metric function
  P = GeoStats.pairwise((x,y) -> sum(x+y), eye(10))
  @test all(P .== 2)

  # empirical distribution
  values = randn(1000)
  d = EmpiricalDistribution(values)
  @test 0. ≤ cdf(d, rand()) ≤ 1.
  @test minimum(values) ≤ quantile(d, .5) ≤ maximum(values)
end
