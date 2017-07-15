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
    ExternalDriftKriging(X, z, γ, ms)

## Parameters

* X ∈ ℜ^(mxn) - matrix of data locations
* z ∈ ℜⁿ      - vector of observations for X
* γ           - variogram model
* ms          - vector of external drift functions m: ℜᵐ ↦ ℜ

### Notes

* External drift functions should be smooth
* Kriging system with external drift is often unstable
* Include a constant drift (e.g. `x->1`) for unbiased estimation
* [`OrdinaryKriging`](@ref) is recovered for `ms = [x->1]`
* For polynomial mean, see [`UniversalKriging`](@ref)
"""
mutable struct ExternalDriftKriging{T<:Real,V} <: AbstractEstimator
  # input fields
  X::AbstractMatrix{T}
  z::AbstractVector{V}
  γ::AbstractVariogram
  ms::AbstractVector{Function}

  # state fields
  LU::Base.LinAlg.Factorization{T}

  function ExternalDriftKriging{T,V}(X, z, γ, ms) where {T<:Real,V}
    @assert size(X, 2) == length(z) "incorrect data configuration"
    EDK = new(X, z, γ, ms)
    fit!(EDK, X, z)
    EDK
  end
end

ExternalDriftKriging(X, z, γ, ms) = ExternalDriftKriging{eltype(X),eltype(z)}(X, z, γ, ms)

function fit!(estimator::ExternalDriftKriging{T,V},
              X::AbstractMatrix{T}, z::AbstractVector{V}) where {T<:Real,V}
  # update data
  estimator.X = X
  estimator.z = z

  dim, nobs = size(X)
  ms = estimator.ms

  # variogram/covariance
  γ = estimator.γ
  cov(x,y) = γ.sill - γ(x,y)

  # use covariance matrix if possible
  if isstationary(γ)
    Γ = pairwise((x,y) -> cov(x,y), X)
  else
    Γ = pairwise((x,y) -> γ(x,y), X)
  end

  # polynomial drift matrix
  ndrifts = length(ms)
  F = [m(X[:,i]) for i=1:nobs, m in ms]

  # LHS of Kriging system
  A = [Γ F; F' zeros(ndrifts,ndrifts)]

  # factorize
  estimator.LU = lufact(A)
end

function weights(estimator::ExternalDriftKriging{T,V}, xₒ::AbstractVector{T}) where {T<:Real,V}
  X = estimator.X; z = estimator.z; ms = estimator.ms
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

  # evaluate drift at location
  f = [m(xₒ) for m in ms]

  # solve linear system
  b = [g; f]
  x = LU \ b

  # return weights
  ExternalDriftKrigingWeights(estimator, x[1:nobs], x[nobs+1:end], b)
end

"""
    ExternalDriftKrigingWeights(estimator, λ, ν, b)

Container that holds weights `λ`, Lagrange multipliers `ν` and RHS `b` for `estimator`.
"""
struct ExternalDriftKrigingWeights{T<:Real,V} <: AbstractWeights{ExternalDriftKriging{T,V}}
  estimator::ExternalDriftKriging{T,V}
  λ::AbstractVector{T}
  ν::AbstractVector{T}
  b::AbstractVector{T}
end

function combine(weights::ExternalDriftKrigingWeights{T,V}) where {T<:Real,V}
  z = weights.estimator.z; γ = weights.estimator.γ
  λ = weights.λ; ν = weights.ν; b = weights.b

  if isstationary(γ)
    z⋅λ, γ.sill - b⋅[λ;ν]
  else
    z⋅λ, b⋅[λ;ν]
  end
end
