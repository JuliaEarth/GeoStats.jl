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

*INPUTS*:

  * X ∈ ℜ^(mxn) - matrix of data locations
  * z ∈ ℜⁿ      - vector of observations for X
  * γ           - variogram model
  * degree      - polynomial degree for the mean

Ordinary Kriging is recovered for 0th degree polynomial.
"""
type UniversalKriging{T<:Real,V} <: AbstractEstimator
  # input fields
  X::AbstractMatrix{T}
  z::AbstractVector{V}
  γ::AbstractVariogram
  degree::Integer

  # state fields
  LU::Base.LinAlg.Factorization{T}
  exponents::AbstractMatrix{Int}

  function UniversalKriging{T,V}(X, z, γ, degree) where {T<:Real,V}
    @assert size(X, 2) == length(z) "incorrect data configuration"
    @assert degree ≥ 0 "degree must be nonnegative"
    UK = new(X, z, γ, degree)
    fit!(UK, X, z)
    UK
  end
end

UniversalKriging(X, z, γ, degree) = UniversalKriging{eltype(X),eltype(z)}(X, z, γ, degree)

function fit!(estimator::UniversalKriging{T,V},
              X::AbstractMatrix{T}, z::AbstractVector{V}) where {T<:Real,V}
  # update data
  estimator.X = X
  estimator.z = z

  dim, nobs = size(X)
  γ = estimator.γ

  # variogram matrix
  Γ = pairwise((x,y) -> γ(x,y), X)

  # multinomial expansion
  exponents = zeros(Int, 0, dim)
  for d=0:estimator.degree
    exponents = [exponents; multinom_exp(dim, d, sortdir="descend")]
  end
  exponents = exponents'

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
  X = estimator.X; z = estimator.z; γ = estimator.γ
  exponents = estimator.exponents
  LU = estimator.LU
  nobs = length(z)

  # evaluate variogram at location
  g = [γ(X[:,j],xₒ) for j=1:nobs]

  # evaluate multinomial at location
  nterms = size(exponents, 2)
  f = [prod(xₒ.^exponents[:,j]) for j=1:nterms]

  # solve linear system
  b = [g; f]
  x = LU \ b

  # return weights
  UniversalKrigingWeights(estimator, x[1:nobs], x[nobs+1:end], b)
end

function estimate(estimator::UniversalKriging{T,V}, xₒ::AbstractVector{T}) where {T<:Real,V}
  # compute weights
  UKweights = weights(estimator, xₒ)

  # estimate and variance
  combine(UKweights)
end

"""
    UniversalKrigingWeights(estimator, λ, ν, b)

Container that holds weights `λ`, Lagrange multipliers `ν` and RHS `b` for `estimator`.
"""
immutable UniversalKrigingWeights{T<:Real,V} <: AbstractWeights{UniversalKriging{T,V}}
  estimator::UniversalKriging{T,V}
  λ::AbstractVector{T}
  ν::AbstractVector{T}
  b::AbstractVector{T}
end

function combine(weights::UniversalKrigingWeights{T,V}) where {T<:Real,V}
  z = weights.estimator.z
  λ = weights.λ; ν = weights.ν; b = weights.b

  z⋅λ, b⋅[λ;ν]
end
