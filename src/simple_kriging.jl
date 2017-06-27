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

*INPUTS*:

  * X ∈ ℜ^(mxn) - matrix of data locations
  * z ∈ ℜⁿ      - vector of observations for X
  * γ           - variogram model
  * μ ∈ ℜ       - mean of z
"""
type SimpleKriging{T<:Real,V} <: AbstractEstimator
  # input fields
  X::AbstractMatrix{T}
  z::AbstractVector{V}
  γ::AbstractVariogram
  μ::V

  # state fields
  LLᵀ::Base.LinAlg.Factorization{T}

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
  cov(x,y) = γ.sill - γ(x,y)

  # LHS of Kriging system
  C = pairwise((x,y) -> cov(x,y), X)

  # factorize
  estimator.LLᵀ = cholfact(C)
end

function weights(estimator::SimpleKriging{T,V}, xₒ::AbstractVector{T}) where {T<:Real,V}
  X = estimator.X; z = estimator.z
  γ = estimator.γ; μ = estimator.μ
  cov(x,y) = γ.sill - γ(x,y)
  LLᵀ = estimator.LLᵀ
  nobs = length(z)

  # evaluate covariance at location
  c = [cov(X[:,j],xₒ) for j=1:nobs]

  # solve linear system
  y = z - μ
  λ = LLᵀ \ c

  # return weights
  SimpleKrigingWeights(estimator, λ, y, c)
end

function estimate(estimator::SimpleKriging{T,V}, xₒ::AbstractVector{T}) where {T<:Real,V}
  # compute weights
  SKweights = weights(estimator, xₒ)

  # return estimate and variance
  combine(SKweights)
end

"""
    SimpleKrigingWeights(estimator, λ, y, c)

Container that holds weights `λ`, centralized data `y` and RHS covariance `c` for `estimator`.
"""
immutable SimpleKrigingWeights{T<:Real,V} <: AbstractWeights{SimpleKriging{T,V}}
  estimator::SimpleKriging{T,V}
  λ::AbstractVector{T}
  y::AbstractVector{V}
  c::AbstractVector{T}
end

function combine(weights::SimpleKrigingWeights{T,V}) where {T<:Real,V}
  γ = weights.estimator.γ; μ = weights.estimator.μ
  λ = weights.λ; y = weights.y; c = weights.c

  μ + y⋅λ, γ.sill - c⋅λ
end
