using GeoStats
using Base.Test

# floating point tolerance
tol = 10eps()

dim = 3; nobs = 10
X = rand(dim, nobs); z = rand(nobs)
x₀ = rand(dim)

@testset "Basic checks" begin
  # Kriging is an interpolator
  for j=1:nobs
    SKestimate, SKvar = kriging(X[:,j], X, z, μ=mean(z))
    OKestimate, OKvar = kriging(X[:,j], X, z)
    UKestimate, UKvar = unikrig(X[:,j], X, z, degree=1)

    @test isapprox(SKestimate, z[j])
    @test isapprox(OKestimate, z[j])
    @test isapprox(UKestimate, z[j])

    # variance checks
    @test SKvar + tol ≥ 0
    @test OKvar + tol ≥ 0
    @test SKvar ≤ OKvar + tol
  end

  # Ordinary Kriging ≡ Universal Kriging with 0th degree drift
  OKestimate, OKvar = kriging(x₀, X, z)
  UKestimate, UKvar = unikrig(x₀, X, z, degree=0)
  @test isapprox(OKestimate, UKestimate)
  @test isapprox(OKvar, UKvar)
end

@testset "Covariance models" begin
  h = linspace(0,100)
  gaussian = GaussianCovariance()
  spherical = SphericalCovariance()
  exponential = ExponentialCovariance()

  # covariance is a decreasing function
  @test all(gaussian(h) .≥ gaussian(h+1))
  @test all(spherical(h) .≥ spherical(h+1))
  @test all(exponential(h) .≥ exponential(h+1))
end
