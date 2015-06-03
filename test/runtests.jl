using GeoStats
using Base.Test

dim = 3; nobs = 10
X = rand(dim,nobs); z = rand(nobs)
x₀ = rand(dim)

# floating point tolerance
tol = 3eps()

# Kriging is an interpolator
for j=1:nobs
  SKestimate, SKvar = kriging(X[:,j], X, z, μ=(nobs+1)/2)
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
