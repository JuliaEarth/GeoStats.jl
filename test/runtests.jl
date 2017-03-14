using GeoStats
using Base.Test

# floating point tolerance
tol = 10eps()

# create some data
dim = 3; nobs = 10
X = rand(dim, nobs); z = rand(nobs)
xₒ = rand(dim)

@testset "Kriging" begin
  cov = GaussianCovariance()
  simkrig = SimpleKriging(X, z, cov, mean(z))
  ordkrig = OrdinaryKriging(X, z, cov)
  unikrig = UniversalKriging(X, z, cov, 1)

  # Kriging is an interpolator
  for j=1:nobs
    SKestimate, SKvar = estimate(simkrig, X[:,j])
    OKestimate, OKvar = estimate(ordkrig, X[:,j])
    UKestimate, UKvar = estimate(unikrig, X[:,j])

    # estimate checks
    @test isapprox(SKestimate, z[j])
    @test isapprox(OKestimate, z[j])
    @test isapprox(UKestimate, z[j])

    # variance checks
    @test SKvar + tol ≥ 0
    @test OKvar + tol ≥ 0
    @test SKvar ≤ OKvar + tol
  end

  # save results on a particular location xₒ
  SKestimate, SKvar = estimate(simkrig, xₒ)
  OKestimate, OKvar = estimate(ordkrig, xₒ)
  UKestimate, UKvar = estimate(unikrig, xₒ)

  # Kriging is translation-invariant
  h = rand(dim)
  simkrig_h = SimpleKriging(X .+ h, z, cov, mean(z))
  ordkrig_h = OrdinaryKriging(X .+ h, z, cov)
  unikrig_h = UniversalKriging(X .+ h, z, cov, 1)
  SKestimate_h, SKvar_h = estimate(simkrig_h, xₒ .+ h)
  OKestimate_h, OKvar_h = estimate(ordkrig_h, xₒ .+ h)
  UKestimate_h, UKvar_h = estimate(unikrig_h, xₒ .+ h)
  @test isapprox(SKestimate, SKestimate_h)
  @test isapprox(SKvar, SKvar_h)
  @test isapprox(OKestimate, OKestimate_h)
  @test isapprox(OKvar, OKvar_h)
  @test isapprox(UKestimate, UKestimate_h)
  @test isapprox(UKvar, UKvar_h)

  # Kriging estimate is invariant under covariance scaling
  # Kriging variance is multiplied by the same factor
  α = rand()
  cov_α = GaussianCovariance(0., α, 1.)
  simkrig_α = SimpleKriging(X, z, cov_α, mean(z))
  ordkrig_α = OrdinaryKriging(X, z, cov_α)
  unikrig_α = UniversalKriging(X, z, cov_α, 1)
  SKestimate_α, SKvar_α = estimate(simkrig_α, xₒ)
  OKestimate_α, OKvar_α = estimate(ordkrig_α, xₒ)
  UKestimate_α, UKvar_α = estimate(unikrig_α, xₒ)
  @test isapprox(SKestimate_α, SKestimate)
  @test isapprox(SKvar_α, α*SKvar)
  @test isapprox(OKestimate_α, OKestimate)
  @test isapprox(OKvar_α, α*OKvar)
  @test isapprox(UKestimate_α, UKestimate)
  @test isapprox(UKvar_α, α*UKvar)

  # Kriging variance is a function of data configuration, not data values
  δ = rand(nobs)
  z_δ = z .+ δ
  simkrig_δ = SimpleKriging(X, z_δ, cov, mean(z_δ))
  ordkrig_δ = OrdinaryKriging(X, z_δ, cov)
  unikrig_δ = UniversalKriging(X, z_δ, cov, 1)
  SKestimate_δ, SKvar_δ = estimate(simkrig_δ, xₒ)
  OKestimate_δ, OKvar_δ = estimate(ordkrig_δ, xₒ)
  UKestimate_δ, UKvar_δ = estimate(unikrig_δ, xₒ)
  @test isapprox(SKvar, SKvar_δ)
  @test isapprox(OKvar, OKvar_δ)
  @test isapprox(UKvar, UKvar_δ)

  # Ordinary Kriging ≡ Universal Kriging with 0th degree drift
  unikrig_0th = UniversalKriging(X, z, cov, 0)
  OKestimate, OKvar = estimate(ordkrig, xₒ)
  UKestimate, UKvar = estimate(unikrig_0th, xₒ)
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
