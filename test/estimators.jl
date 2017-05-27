@testset "Kriging" begin
  γ = GaussianVariogram()
  simkrig = SimpleKriging(X, z, γ, mean(z))
  ordkrig = OrdinaryKriging(X, z, γ)
  unikrig = UniversalKriging(X, z, γ, 1)

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
  simkrig_h = SimpleKriging(X .+ h, z, γ, mean(z))
  ordkrig_h = OrdinaryKriging(X .+ h, z, γ)
  unikrig_h = UniversalKriging(X .+ h, z, γ, 1)
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
  γ_α = GaussianVariogram(α, 1.)
  simkrig_α = SimpleKriging(X, z, γ_α, mean(z))
  ordkrig_α = OrdinaryKriging(X, z, γ_α)
  unikrig_α = UniversalKriging(X, z, γ_α, 1)
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
  simkrig_δ = SimpleKriging(X, z_δ, γ, mean(z_δ))
  ordkrig_δ = OrdinaryKriging(X, z_δ, γ)
  unikrig_δ = UniversalKriging(X, z_δ, γ, 1)
  SKestimate_δ, SKvar_δ = estimate(simkrig_δ, xₒ)
  OKestimate_δ, OKvar_δ = estimate(ordkrig_δ, xₒ)
  UKestimate_δ, UKvar_δ = estimate(unikrig_δ, xₒ)
  @test isapprox(SKvar, SKvar_δ)
  @test isapprox(OKvar, OKvar_δ)
  @test isapprox(UKvar, UKvar_δ)

  # Ordinary Kriging ≡ Universal Kriging with 0th degree drift
  unikrig_0th = UniversalKriging(X, z, γ, 0)
  OKestimate, OKvar = estimate(ordkrig, xₒ)
  UKestimate, UKvar = estimate(unikrig_0th, xₒ)
  @test isapprox(OKestimate, UKestimate)
  @test isapprox(OKvar, UKvar)
end
