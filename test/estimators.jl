@testset "Kriging estimators" begin
  γ = GaussianVariogram(sill=1., range=1., nugget=0.)
  simkrig = SimpleKriging(X, z, γ, mean(z))
  ordkrig = OrdinaryKriging(X, z, γ)
  unikrig = UniversalKriging(X, z, γ, 1)
  driftkrig = ExternalDriftKriging(X, z, γ, [x->1.])

  # Kriging is an interpolator
  for j=1:nobs
    SKestimate, SKvar = estimate(simkrig, X[:,j])
    OKestimate, OKvar = estimate(ordkrig, X[:,j])
    UKestimate, UKvar = estimate(unikrig, X[:,j])
    DKestimate, DKvar = estimate(driftkrig, X[:,j])

    # estimate checks
    @test SKestimate ≈ z[j]
    @test OKestimate ≈ z[j]
    @test UKestimate ≈ z[j]
    @test DKestimate ≈ z[j]

    # variance checks
    @test SKvar + tol ≥ 0
    @test OKvar + tol ≥ 0
    @test UKvar + tol ≥ 0
    @test DKvar + tol ≥ 0
    @test SKvar ≤ OKvar + tol
  end

  # save results on a particular location xₒ
  SKestimate, SKvar = estimate(simkrig, xₒ)
  OKestimate, OKvar = estimate(ordkrig, xₒ)
  UKestimate, UKvar = estimate(unikrig, xₒ)
  DKestimate, DKvar = estimate(driftkrig, xₒ)

  # Kriging is translation-invariant
  h = rand(dim)
  simkrig_h = SimpleKriging(X .+ h, z, γ, mean(z))
  ordkrig_h = OrdinaryKriging(X .+ h, z, γ)
  unikrig_h = UniversalKriging(X .+ h, z, γ, 1)
  driftkrig_h = ExternalDriftKriging(X .+ h, z, γ, [x->1.])
  SKestimate_h, SKvar_h = estimate(simkrig_h, xₒ .+ h)
  OKestimate_h, OKvar_h = estimate(ordkrig_h, xₒ .+ h)
  UKestimate_h, UKvar_h = estimate(unikrig_h, xₒ .+ h)
  DKestimate_h, DKvar_h = estimate(driftkrig_h, xₒ .+ h)
  @test SKestimate_h ≈ SKestimate
  @test SKvar_h ≈ SKvar
  @test OKestimate_h ≈ OKestimate
  @test OKvar_h ≈ OKvar
  @test UKestimate_h ≈ UKestimate
  @test UKvar_h ≈ UKvar
  @test DKestimate_h ≈ DKestimate
  @test DKvar_h ≈ DKvar

  # Kriging estimate is invariant under covariance scaling
  # Kriging variance is multiplied by the same factor
  α = rand()
  γ_α = GaussianVariogram(sill=α, range=1., nugget=0.)
  simkrig_α = SimpleKriging(X, z, γ_α, mean(z))
  ordkrig_α = OrdinaryKriging(X, z, γ_α)
  unikrig_α = UniversalKriging(X, z, γ_α, 1)
  driftkrig_α = ExternalDriftKriging(X, z, γ_α, [x->1.])
  SKestimate_α, SKvar_α = estimate(simkrig_α, xₒ)
  OKestimate_α, OKvar_α = estimate(ordkrig_α, xₒ)
  UKestimate_α, UKvar_α = estimate(unikrig_α, xₒ)
  DKestimate_α, DKvar_α = estimate(driftkrig_α, xₒ)
  @test SKestimate_α ≈ SKestimate
  @test SKvar_α ≈ α*SKvar
  @test OKestimate_α ≈ OKestimate
  @test OKvar_α ≈ α*OKvar
  @test UKestimate_α ≈ UKestimate
  @test UKvar_α ≈ α*UKvar
  @test DKestimate_α ≈ DKestimate
  @test DKvar_α ≈ α*DKvar

  # Kriging variance is a function of data configuration, not data values
  δ = rand(nobs)
  z_δ = z .+ δ
  simkrig_δ = SimpleKriging(X, z_δ, γ, mean(z_δ))
  ordkrig_δ = OrdinaryKriging(X, z_δ, γ)
  unikrig_δ = UniversalKriging(X, z_δ, γ, 1)
  driftkrig_δ = ExternalDriftKriging(X, z_δ, γ, [x->1.])
  SKestimate_δ, SKvar_δ = estimate(simkrig_δ, xₒ)
  OKestimate_δ, OKvar_δ = estimate(ordkrig_δ, xₒ)
  UKestimate_δ, UKvar_δ = estimate(unikrig_δ, xₒ)
  DKestimate_δ, DKvar_δ = estimate(driftkrig_δ, xₒ)
  @test SKvar_δ ≈ SKvar
  @test OKvar_δ ≈ OKvar
  @test UKvar_δ ≈ UKvar
  @test DKvar_δ ≈ DKvar

  # Ordinary Kriging ≡ Universal Kriging with 0th degree drift
  unikrig_0th = UniversalKriging(X, z, γ, 0)
  OKestimate, OKvar = estimate(ordkrig, xₒ)
  UKestimate, UKvar = estimate(unikrig_0th, xₒ)
  @test OKestimate ≈ UKestimate
  @test OKvar ≈ UKvar

  # Ordinary Kriging ≡ Kriging with constant external drift
  driftkrig_const = ExternalDriftKriging(X, z, γ, [x->1.])
  OKestimate, OKvar = estimate(ordkrig, xₒ)
  DKestimate, DKvar = estimate(driftkrig_const, xₒ)
  @test OKestimate ≈ DKestimate
  @test OKvar ≈ DKvar

  # Non-stationary variograms are allowed
  γ_ns = PowerVariogram()
  ordkrig_ns = OrdinaryKriging(X, z, γ_ns)
  unikrig_ns = UniversalKriging(X, z, γ_ns, 1)
  driftkrig_ns = ExternalDriftKriging(X, z, γ_ns, [x->1.])
  for j=1:nobs
    OKestimate, OKvar = estimate(ordkrig_ns, X[:,j])
    UKestimate, UKvar = estimate(unikrig_ns, X[:,j])
    DKestimate, DKvar = estimate(driftkrig_ns, X[:,j])

    # estimate checks
    @test OKestimate ≈ z[j]
    @test UKestimate ≈ z[j]
    @test DKestimate ≈ z[j]

    # variance checks
    @test OKvar + tol ≥ 0
    @test UKvar + tol ≥ 0
    @test DKvar + tol ≥ 0
  end

  # Floating point precision checks
  X_f  = rand(Float32, dim, nobs)
  z_f  = rand(Float32, nobs)
  xₒ_f = rand(Float32, dim)
  γ_f = GaussianVariogram(sill=1f0, range=1f0, nugget=0f0)
  X_d  = Float64.(X_f)
  z_d  = Float64.(z_f)
  xₒ_d = Float64.(xₒ_f)
  γ_d = GaussianVariogram(sill=1., range=1., nugget=0.)
  simkrig_f = SimpleKriging(X_f, z_f, γ_f, mean(z_f))
  ordkrig_f = OrdinaryKriging(X_f, z_f, γ_f)
  unikrig_f = UniversalKriging(X_f, z_f, γ_f, 1)
  driftkrig_f = ExternalDriftKriging(X_f, z_f, γ_f, [x->1f0])
  simkrig_d = SimpleKriging(X_d, z_d, γ_d, mean(z_d))
  ordkrig_d = OrdinaryKriging(X_d, z_d, γ_d)
  unikrig_d = UniversalKriging(X_d, z_d, γ_d, 1)
  driftkrig_d = ExternalDriftKriging(X_d, z_d, γ_d, [x->1.])
  SKestimate_f, SKvar_f = estimate(simkrig_f, xₒ_f)
  OKestimate_f, OKvar_f = estimate(ordkrig_f, xₒ_f)
  UKestimate_f, UKvar_f = estimate(unikrig_f, xₒ_f)
  DKestimate_f, DKvar_f = estimate(driftkrig_f, xₒ_f)
  SKestimate_d, SKvar_d = estimate(simkrig_d, xₒ_d)
  OKestimate_d, OKvar_d = estimate(ordkrig_d, xₒ_d)
  UKestimate_d, UKvar_d = estimate(unikrig_d, xₒ_d)
  DKestimate_d, DKvar_d = estimate(driftkrig_d, xₒ_d)
  @test isapprox(SKestimate_f, SKestimate_d, atol=1e-4)
  @test isapprox(SKvar_f, SKvar_d, atol=1e-4)
  @test isapprox(OKestimate_f, OKestimate_d, atol=1e-4)
  @test isapprox(OKvar_f, OKvar_d, atol=1e-4)
  @test isapprox(UKestimate_f, UKestimate_d, atol=1e-4)
  @test isapprox(UKvar_f, UKvar_d, atol=1e-4)
  @test isapprox(DKestimate_f, DKestimate_d, atol=1e-4)
  @test isapprox(DKvar_f, DKvar_d, atol=1e-4)
end
