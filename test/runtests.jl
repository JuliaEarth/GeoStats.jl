using GeoStats
using Base.Test

# floating point tolerance
tol = 10eps()

dim = 3; nobs = 10
X = rand(dim, nobs); z = rand(nobs)
xₒ = rand(dim)

@testset "Basic checks" begin
  cov = GaussianCovariance()
  simkrig = SimpleKriging(X, z, cov, mean(z))
  ordkrig = OrdinaryKriging(X, z, cov)
  unikrig = UniversalKriging(X, z, cov, 1)

  # Kriging is an interpolator
  for j=1:nobs
    SKestimate, SKvar = estimate(simkrig, X[:,j])
    OKestimate, OKvar = estimate(ordkrig, X[:,j])
    UKestimate, UKvar = estimate(unikrig, X[:,j])

    @test isapprox(SKestimate, z[j])
    @test isapprox(OKestimate, z[j])
    @test isapprox(UKestimate, z[j])

    # variance checks
    @test SKvar + tol ≥ 0
    @test OKvar + tol ≥ 0
    @test SKvar ≤ OKvar + tol
  end

  # Ordinary Kriging ≡ Universal Kriging with 0th degree drift
  unikrig = UniversalKriging(X, z, cov, 0)
  OKestimate, OKvar = estimate(ordkrig, xₒ)
  UKestimate, UKvar = estimate(unikrig, xₒ)
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
