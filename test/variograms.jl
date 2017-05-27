@testset "Variogram" begin
  h = linspace(0,100)
  gaussian = GaussianVariogram()
  spherical = SphericalVariogram()
  exponential = ExponentialVariogram()

  # variograms are increasing functions
  @test all(gaussian(h) .≤ gaussian(h+1))
  @test all(spherical(h) .≤ spherical(h+1))
  @test all(exponential(h) .≤ exponential(h+1))
end
