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

"""
    AbstractEstimator

A spatial estimator (e.g. Simple Kriging).
"""
abstract type AbstractEstimator end

"""
    fit!(estimator, X, z)

Build Kriging system from locations `X` with values `z` and save factorization in `estimator`.
"""
function fit!(estimator::AbstractEstimator, X::AbstractMatrix, z::AbstractVector)
  # update data
  estimator.X = X
  estimator.z = z

  # variogram/covariance
  γ = estimator.γ
  Γ = isstationary(γ) ? γ.sill - pairwise(γ, X) : pairwise(γ, X)

  # build and factorize LHS
  estimator.LHS = factorize(estimator, build_lhs!(estimator, Γ))
end

"""
    weights(estimator, xₒ)

Compute the weights λ (and Lagrange multipliers ν) for the `estimator` at coordinates `xₒ`.
"""
function weights(estimator::AbstractEstimator, xₒ::AbstractVector)
  X = estimator.X
  γ = estimator.γ
  nobs = size(X, 2)

  # evaluate variogram/covariance at location
  if isstationary(γ)
    g = γ.sill - [γ(X[:,j], xₒ) for j=1:nobs]
  else
    g = [γ(X[:,j], xₒ) for j=1:nobs]
  end

  # build RHS
  estimator.RHS = build_rhs!(estimator, g, xₒ)

  # solve linear system
  x = estimator.LHS \ estimator.RHS

  # return weights
  Weights(x[1:nobs], x[nobs+1:end])
end

"""
    estimate(estimator, xₒ)

Compute mean and variance for the `estimator` at coordinates `xₒ`.
"""
estimate(estimator::AbstractEstimator, xₒ::AbstractVector) = combine(estimator, weights(estimator, xₒ), estimator.z)

"""
    build_lhs!(estimator, Γ)

Augment variogram matrix `Γ` to produce LHS of Kriging system.
"""
build_lhs!(estimator::AbstractEstimator, Γ::AbstractMatrix) = error("not implemented")

"""
    build_rhs!(estimator, g, xₒ)

Augment variogram vector `g` to produce RHS of Kriging system at point `xₒ`.
"""
build_rhs!(estimator::AbstractEstimator, g::AbstractVector, xₒ::AbstractVector) = error("not implemented")

"""
    factorize(estimator, LHS)

Factorize `LHS` for `estimator` with appropriate factorization method.
"""
factorize(estimator::AbstractEstimator, LHS::AbstractMatrix) = lufact(LHS)

"""
    Weights(λ, ν)

An object storing Kriging weights `λ` and Lagrange multipliers `ν`.
"""
struct Weights{T<:Real}
  λ::Vector{T}
  ν::Vector{T}
end

"""
    combine(estimator, weights, z)

Combine `weights` with values `z` to produce mean and variance.
"""
function combine(estimator::AbstractEstimator, weights::Weights, z::AbstractVector)
  γ = estimator.γ
  b = estimator.RHS
  λ = weights.λ
  ν = weights.ν

  if isstationary(γ)
    z⋅λ, γ.sill - b⋅[λ;ν]
  else
    z⋅λ, b⋅[λ;ν]
  end
end

#------------------
# IMPLEMENTATIONS
#------------------
include("estimators/simple_kriging.jl")
include("estimators/ordinary_kriging.jl")
include("estimators/universal_kriging.jl")
include("estimators/external_drift_kriging.jl")
