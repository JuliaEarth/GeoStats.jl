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
    OrdinaryKriging(X, z, γ)

## Parameters

* X ∈ ℜ^(mxn) - matrix of data locations
* z ∈ ℜⁿ      - vector of observations for X
* γ           - variogram model
"""
mutable struct OrdinaryKriging{T<:Real,V} <: AbstractEstimator
  # input fields
  X::AbstractMatrix{T}
  z::AbstractVector{V}
  γ::AbstractVariogram

  # state fields
  LU::Base.LinAlg.Factorization{T}

  function OrdinaryKriging{T,V}(X, z, γ) where {T<:Real,V}
    @assert size(X, 2) == length(z) "incorrect data configuration"
    OK = new(X, z, γ)
    fit!(OK, X, z)
    OK
  end
end

OrdinaryKriging(X, z, γ) = OrdinaryKriging{eltype(X),eltype(z)}(X, z, γ)

function fit!(estimator::OrdinaryKriging{T,V},
              X::AbstractMatrix{T}, z::AbstractVector{V}) where {T<:Real,V}
  # udpate data
  estimator.X = X
  estimator.z = z

  nobs = size(X,2)

  # variogram/covariance
  γ = estimator.γ

  # LHS of Kriging system
  Γ = pairwise((x,y) -> γ(x,y), X)
  A = [Γ ones(nobs); ones(nobs)' 0]

  # factorize
  estimator.LU = lufact(A)
end

function weights(estimator::OrdinaryKriging{T,V}, xₒ::AbstractVector{T}) where {T<:Real,V}
  X = estimator.X; z = estimator.z; γ = estimator.γ
  LU = estimator.LU
  nobs = length(z)

  # evaluate variogram/covariance at location
  g = [γ(X[:,j],xₒ) for j=1:nobs]

  # solve linear system
  b = [g; 1]
  x = LU \ b

  # return weights
  OrdinaryKrigingWeights(estimator, x[1:nobs], x[nobs+1:end], b)
end

"""
    OrdinaryKrigingWeights(estimator, λ, ν, b)

Container that holds weights `λ`, Lagrange multipliers `ν` and RHS `b` for `estimator`.
"""
struct OrdinaryKrigingWeights{T<:Real,V} <: AbstractWeights{OrdinaryKriging{T,V}}
  estimator::OrdinaryKriging{T,V}
  λ::AbstractVector{T}
  ν::AbstractVector{T}
  b::AbstractVector{T}
end

function combine(weights::OrdinaryKrigingWeights{T,V}) where {T<:Real,V}
  γ = weights.estimator.γ; z = weights.estimator.z
  λ = weights.λ; ν = weights.ν; b = weights.b

  z⋅λ, b⋅[λ;ν]
end
