## Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
##
## Permission to use, copy, modify, and/or distribute this software for any
## purpose with or without fee is hereby granted, provided that the above
## copyright notice and this permission notice appear in all copies.
##
## THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
## WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
## ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
## WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
## ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
## OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

"""
    UniversalKriging(X, z, γ, degree)

## Parameters

* X ∈ ℜ^(mxn) - matrix of data locations
* z ∈ ℜⁿ      - vector of observations for X
* γ           - variogram model
* degree      - polynomial degree for the mean

### Notes

* [`OrdinaryKriging`](@ref) is recovered for 0th degree polynomial
* For non-polynomial mean, see [`ExternalDriftKriging`](@ref)
"""
mutable struct UniversalKriging{T<:Real,V} <: AbstractEstimator
  # input fields
  γ::AbstractVariogram
  degree::Int

  # state fields
  X::Matrix{T}
  z::Vector{V}
  LU::Base.LinAlg.Factorization{T}
  exponents::AbstractMatrix{Int}

  function UniversalKriging{T,V}(γ, degree; X=nothing, z=nothing) where {T<:Real,V}
    @assert degree ≥ 0 "degree must be nonnegative"
    UK = new(γ, degree)
    if X ≠ nothing && z ≠ nothing
      fit!(UK, X, z)
    end

    UK
  end
end

UniversalKriging(X, z, γ, degree) = UniversalKriging{eltype(X),eltype(z)}(γ, degree, X=X, z=z)

function fit!(estimator::UniversalKriging{T,V},
              X::AbstractMatrix{T}, z::AbstractVector{V}) where {T<:Real,V}
  # update data
  estimator.X = X
  estimator.z = z

  dim, nobs = size(X)

  # variogram/covariance
  γ = estimator.γ

  # use covariance matrix if possible
  Γ = isstationary(γ) ? γ.sill - pairwise(γ, X) : pairwise(γ, X)

  # multinomial expansion
  expmats = [hcat(collect(multiexponents(dim, d))...) for d in 0:estimator.degree]
  exponents = hcat(expmats...)

  # sort expansion for better conditioned Kriging matrices
  sorted = sortperm(vec(maximum(exponents, 1)), rev=true)
  exponents = exponents[:,sorted]

  # update object field
  estimator.exponents = exponents

  # polynomial drift matrix
  nterms = size(exponents, 2)
  F = [prod(X[:,i].^exponents[:,j]) for i=1:nobs, j=1:nterms]

  # LHS of Kriging system
  A = [Γ F; F' zeros(nterms,nterms)]

  # factorize
  estimator.LU = lufact(A)
end

function weights(estimator::UniversalKriging{T,V}, xₒ::AbstractVector{T}) where {T<:Real,V}
  X = estimator.X; z = estimator.z
  exponents = estimator.exponents
  LU = estimator.LU

  nobs = length(z)

  # variogram/covariance
  γ = estimator.γ
  cov(x,y) = γ.sill - γ(x,y)

  # evaluate variogram at location
  if isstationary(γ)
    g = [cov(X[:,j],xₒ) for j=1:nobs]
  else
    g = [γ(X[:,j],xₒ) for j=1:nobs]
  end

  # evaluate multinomial at location
  nterms = size(exponents, 2)
  f = [prod(xₒ.^exponents[:,j]) for j=1:nterms]

  # solve linear system
  b = [g; f]
  x = LU \ b

  # return weights
  UniversalKrigingWeights(estimator, x[1:nobs], x[nobs+1:end], b)
end

"""
    UniversalKrigingWeights(estimator, λ, ν, b)

Container that holds weights `λ`, Lagrange multipliers `ν` and RHS `b` for `estimator`.
"""
struct UniversalKrigingWeights{T<:Real,V} <: AbstractWeights{UniversalKriging{T,V}}
  estimator::UniversalKriging{T,V}
  λ::Vector{T}
  ν::Vector{T}
  b::Vector{T}
end

function combine(weights::UniversalKrigingWeights{T,V}) where {T<:Real,V}
  z = weights.estimator.z; γ = weights.estimator.γ
  λ = weights.λ; ν = weights.ν; b = weights.b

  if isstationary(γ)
    z⋅λ, γ.sill - b⋅[λ;ν]
  else
    z⋅λ, b⋅[λ;ν]
  end
end
