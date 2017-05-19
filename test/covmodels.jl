@testset "Covariance" begin
  h = linspace(0,100)
  gaussian = GaussianCovariance()
  spherical = SphericalCovariance()
  exponential = ExponentialCovariance()

  # covariance is a decreasing function
  @test all(gaussian(h) .≥ gaussian(h+1))
  @test all(spherical(h) .≥ spherical(h+1))
  @test all(exponential(h) .≥ exponential(h+1))
end
