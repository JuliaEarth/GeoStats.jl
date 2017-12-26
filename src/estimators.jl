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

  # build LHS
  A = build_lhs!(estimator, Γ)

  # save factorization
  fact = factmethod(estimator)
  estimator.LU = fact(A)
end

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
    factmethod(A)

Return appropriate factorization method for `estimator`.
"""
factmethod(estimator::AbstractEstimator) = error("not implemented")

"""
    weights(estimator, xₒ)

Compute the weights λ (and Lagrange multipliers ν) for the `estimator` at coordinates `xₒ`.
"""
weights(estimator::AbstractEstimator, xₒ::AbstractVector) = error("not implemented")

"""
    estimate(estimator, xₒ)

Compute mean and variance for the `estimator` at coordinates `xₒ`.
"""
estimate(estimator::AbstractEstimator, xₒ::AbstractVector) = combine(weights(estimator, xₒ))

"""
    AbstractWeights

An object to hold weights and related parameters for an estimator of type `E`.
"""
abstract type AbstractWeights{E} end

"""
    combine(weights)

Combine weights (and related parameters) into mean and variance.
"""
combine(weights::AbstractWeights) = error("not implemented")

#------------------
# IMPLEMENTATIONS
#------------------
include("estimators/simple_kriging.jl")
include("estimators/ordinary_kriging.jl")
include("estimators/universal_kriging.jl")
include("estimators/external_drift_kriging.jl")
