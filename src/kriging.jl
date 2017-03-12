## Copyright (c) 2015, Júlio Hoffimann Mendes <juliohm@stanford.edu>
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

abstract AbstractEstimator
@doc doc"""
  Evaluate estimator at a given location
""" ->
estimate(::AbstractEstimator, xₒ::AbstractVector) = nothing

@doc doc"""
  Simple Kriging

    * X  ∈ ℜ^(mxn) - matrix of data locations
    * z  ∈ ℜⁿ      - vector of observations for X
    * cov          - covariance model
    * μ  ∈ ℜ       - mean of z
  """ ->
type SimpleKriging{T<:Real} <: AbstractEstimator
  # input fields
  X::AbstractMatrix{T}
  z::AbstractVector{T}
  cov::CovarianceModel
  μ::T

  # state fields
  C::AbstractMatrix{T}

  function SimpleKriging(X, z, cov, μ)
    @assert size(X, 2) == length(z) "incorrect data configuration"
    C = pairwise(cov, X)
    new(X, z, cov, μ, C)
  end
end
SimpleKriging(X, z, cov, μ) = SimpleKriging{eltype(z)}(X, z, cov, μ)


@doc doc"""
  Ordinary Kriging

    * X  ∈ ℜ^(mxn) - matrix of data locations
    * z  ∈ ℜⁿ      - vector of observations for X
    * cov          - covariance model
  """ ->
type OrdinaryKriging{T<:Real} <: AbstractEstimator
  # input fields
  X::AbstractMatrix{T}
  z::AbstractVector{T}
  cov::CovarianceModel

  # state fields
  C::AbstractMatrix{T}

  function OrdinaryKriging(X, z, cov)
    @assert size(X, 2) == length(z) "incorrect data configuration"
    C = pairwise(cov, X)
    new(X, z, cov, C)
  end
end
OrdinaryKriging(X, z, cov) = OrdinaryKriging{eltype(z)}(X, z, cov)


@doc doc"""
  Universal Kriging (a.k.a. Kriging with drift)

    * X  ∈ ℜ^(mxn) - matrix of data locations
    * z  ∈ ℜⁿ      - vector of observations for X
    * cov          - covariance model
    * degree       - polynomial degree for the mean

  Ordinary Kriging is recovered for 0th degree polynomial.
  """ ->
type UniversalKriging{T<:Real} <: AbstractEstimator
  # input fields
  X:: AbstractMatrix{T}
  z::AbstractVector{T}
  cov::CovarianceModel
  degree::Integer

  # state fields
  Γ::AbstractMatrix{T}
  F::AbstractMatrix{T}
  exponents::AbstractMatrix{Float64}

  function UniversalKriging(X, z, cov, degree)
    @assert size(X, 2) == length(z) "incorrect data configuration"
    @assert degree ≥ 0

    dim = size(X, 1)
    nobs = length(z)

    γ(h) = cov(0) - cov(h)
    Γ = pairwise(γ, X)

    # multinomial expansion
    exponents = zeros(0, dim)
    for d=0:degree
      exponents = [exponents; multinom_exp(dim, d, sortdir="descend")]
    end
    exponents = exponents'

    nterms = size(exponents, 2)

    F = Float64[prod(X[:,i].^exponents[:,j]) for i=1:nobs, j=1:nterms]

    new(X, z, cov, degree, Γ, F, exponents)
  end
end
UniversalKriging(X, z, cov, degree) = UniversalKriging{eltype(z)}(X, z, cov, degree)

##########################
### ESTIMATION METHODS ###
##########################

function estimate{T<:Real}(estimator::SimpleKriging{T}, xₒ::AbstractVector{T})
  X = estimator.X; z = estimator.z
  cov = estimator.cov; μ = estimator.μ
  C = estimator.C

  @assert size(X, 1) == length(xₒ) "incorrect location dimension"

  # evaluate covariance at location
  c = Float64[cov(norm(X[:,j]-xₒ)) for j=1:size(X,2)]

  # solve linear system
  y = z - μ
  λ = C \ c

  # return estimate and variance
  μ + y⋅λ, cov(0) - c⋅λ
end


function estimate{T<:Real}(estimator::OrdinaryKriging{T}, xₒ::AbstractVector{T})
  X = estimator.X; z = estimator.z; cov = estimator.cov
  C = estimator.C

  @assert size(X, 1) == length(xₒ) "incorrect location dimension"

  nobs = length(z)

  # evaluate covariance at location
  c = Float64[cov(norm(X[:,j]-xₒ)) for j=1:nobs]

  # solve linear system
  A = [C ones(nobs); ones(nobs)' 0]
  b = [c; 1]
  λ = A \ b

  # return estimate and variance
  z⋅λ[1:nobs], cov(0) - b⋅λ
end


function estimate{T<:Real}(estimator::UniversalKriging{T}, xₒ::AbstractVector{T})
  X = estimator.X; z = estimator.z
  cov = estimator.cov; degree = estimator.degree
  Γ = estimator.Γ; F = estimator.F; exponents = estimator.exponents

  @assert size(X, 1) == length(xₒ) "incorrect location dimension"

  nobs = length(z)

  # evaluate variogram at location
  γ(h) = cov(0) - cov(h)
  g = Float64[γ(norm(X[:,j]-xₒ)) for j=1:nobs]

  # evaluate multinomial at location
  nterms = size(exponents, 2)
  f = Float64[prod(xₒ.^exponents[:,j]) for j=1:nterms]

  # solve linear system
  A = [Γ F; F' zeros(nterms,nterms)]
  b = [g; f]
  λ = A \ b

  # estimate and variance
  z⋅λ[1:nobs], b⋅λ
end
