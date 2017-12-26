@testset "Distributions" begin
  # empirical distribution
  values = randn(1000)
  d = EmpiricalDistribution(values)
  @test 0. ≤ cdf(d, rand()) ≤ 1.
  @test minimum(values) ≤ quantile(d, .5) ≤ maximum(values)
end
