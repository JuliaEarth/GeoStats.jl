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

### Notes

* Simple Kriging requires stationary variograms
"""
mutable struct SimpleKriging{T<:Real,V} <: AbstractEstimator
  # input fields
  γ::AbstractVariogram
  μ::V

  # state fields
  X::AbstractMatrix{T}
  z::AbstractVector{V}
  LLᵀ::Base.LinAlg.Factorization{T}

  function SimpleKriging{T,V}(γ, μ; X=nothing, z=nothing) where {T<:Real,V}
    @assert isstationary(γ) "Simple Kriging requires stationary variogram"
    SK = new(γ, μ)
    if X ≠ nothing && z ≠ nothing
      fit!(SK, X, z)
    end

    SK
  end
end

SimpleKriging(X, z, γ, μ) = SimpleKriging{eltype(X),eltype(z)}(γ, μ, X=X, z=z)

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
  LLᵀ = estimator.LLᵀ
  nobs = length(z)

  # variogram/covariance
  cov(x,y) = γ.sill - γ(x,y)

  # evaluate variogram/covariance at location
  c = [cov(X[:,j],xₒ) for j=1:nobs]

  # solve linear system
  y = z - μ
  λ = LLᵀ \ c

  # return weights
  SimpleKrigingWeights(estimator, λ, y, c)
end

"""
    SimpleKrigingWeights(estimator, λ, y, c)

Container that holds weights `λ`, centralized data `y` and RHS variogram/covariance `c` for `estimator`.
"""
struct SimpleKrigingWeights{T<:Real,V} <: AbstractWeights{SimpleKriging{T,V}}
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
