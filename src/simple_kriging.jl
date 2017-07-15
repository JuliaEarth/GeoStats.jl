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
    SimpleKriging(X, z, γ, μ)

## Parameters

* X ∈ ℜ^(mxn) - matrix of data locations
* z ∈ ℜⁿ      - vector of observations for X
* γ           - variogram model
* μ ∈ ℜ       - mean of z
"""
mutable struct SimpleKriging{T<:Real,V} <: AbstractEstimator
  # input fields
  X::AbstractMatrix{T}
  z::AbstractVector{V}
  γ::AbstractVariogram
  μ::V

  # state fields
  LU::Base.LinAlg.Factorization{T}

  function SimpleKriging{T,V}(X, z, γ, μ) where {T<:Real,V}
    @assert size(X, 2) == length(z) "incorrect data configuration"
    SK = new(X, z, γ, μ)
    fit!(SK, X, z)
    SK
  end
end

SimpleKriging(X, z, γ, μ) = SimpleKriging{eltype(X),eltype(z)}(X, z, γ, μ)

function fit!(estimator::SimpleKriging{T,V},
              X::AbstractMatrix{T}, z::AbstractVector{V}) where {T<:Real,V}
  # update data
  estimator.X = X
  estimator.z = z

  # variogram/covariance
  γ = estimator.γ

  # LHS of Kriging system
  Γ = pairwise((x,y) -> γ(x,y), X)

  # factorize
  estimator.LU = lufact(Γ)
end

function weights(estimator::SimpleKriging{T,V}, xₒ::AbstractVector{T}) where {T<:Real,V}
  X = estimator.X; z = estimator.z
  γ = estimator.γ; μ = estimator.μ
  LU = estimator.LU
  nobs = length(z)

  # evaluate variogram/covariance at location
  g = [γ(X[:,j],xₒ) for j=1:nobs]

  # solve linear system
  y = z - μ
  λ = LU \ g

  # return weights
  SimpleKrigingWeights(estimator, λ, y, g)
end

"""
    SimpleKrigingWeights(estimator, λ, y, g)

Container that holds weights `λ`, centralized data `y` and RHS variogram/covariance `g` for `estimator`.
"""
struct SimpleKrigingWeights{T<:Real,V} <: AbstractWeights{SimpleKriging{T,V}}
  estimator::SimpleKriging{T,V}
  λ::AbstractVector{T}
  y::AbstractVector{V}
  g::AbstractVector{T}
end

function combine(weights::SimpleKrigingWeights{T,V}) where {T<:Real,V}
  γ = weights.estimator.γ; μ = weights.estimator.μ
  λ = weights.λ; y = weights.y; g = weights.g

  μ + y⋅λ, g⋅λ
end
