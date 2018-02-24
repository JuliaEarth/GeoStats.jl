# ------------------------------------------------------------------
# Copyright (c) 2015, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    AbstractEstimator

A Kriging estimator (e.g. Simple Kriging).
"""
abstract type AbstractEstimator end

"""
    fit!(estimator, X, z)

Build LHS of Kriging system from coordinates `X` with
values `z` and save factorization in `estimator`.
"""
function fit!(estimator::AbstractEstimator, X::AbstractMatrix, z::AbstractVector)
  # update data
  estimator.X = X
  estimator.z = z

  # build and factorize LHS
  set_lhs!(estimator)

  # pre-allocate memory for RHS
  T = eltype(estimator.LHS)
  n = size(estimator.LHS, 1)
  estimator.RHS = Vector{T}(n)

  nothing
end

"""
    estimate(estimator, xₒ)

Compute mean and variance for the `estimator` at coordinates `xₒ`.
"""
estimate(estimator::AbstractEstimator, xₒ::AbstractVector) =
  combine(estimator, weights(estimator, xₒ), estimator.z)

"""
    weights(estimator, xₒ)

Compute the weights λ (and Lagrange multipliers ν) for the
`estimator` at coordinates `xₒ`.
"""
function weights(estimator::AbstractEstimator, xₒ::AbstractVector)
  nobs = size(estimator.X, 2)

  # build RHS
  set_rhs!(estimator, xₒ)

  # solve Kriging system
  x = estimator.LHS \ estimator.RHS

  # return weights
  Weights(x[1:nobs], x[nobs+1:end])
end

"""
    set_lhs!(estimator)

Set LHS of Kriging system.
"""
function set_lhs!(estimator::AbstractEstimator)
  X = estimator.X; γ = estimator.γ

  # LHS variogram/covariance
  Γ = isstationary(γ) ? γ.sill - pairwise(γ, X) : pairwise(γ, X)

  add_constraints_lhs!(estimator, Γ)
end

"""
    set_rhs!(estimator, xₒ)

Set RHS of Kriging system at coodinates `xₒ`.
"""
function set_rhs!(estimator::AbstractEstimator, xₒ::AbstractVector)
  X = estimator.X; γ = estimator.γ

  # RHS variogram/covariance
  RHS = estimator.RHS
  for j in 1:size(X, 2)
    xj = view(X, :, j)
    RHS[j] = isstationary(γ) ? γ.sill - γ(xj, xₒ) : γ(xj, xₒ)
  end

  add_constraints_rhs!(estimator, xₒ)
end

"""
    add_constraints_lhs!(estimator, Γ)

Add constraints to LHS of Kriging system.
"""
add_constraints_lhs!(estimator::AbstractEstimator, Γ::AbstractMatrix) = error("not implemented")

"""
    add_constraints_rhs!(estimator, xₒ)

Add constraints to RHS of Kriging system.
"""
add_constraints_rhs!(estimator::AbstractEstimator, xₒ::AbstractVector) = error("not implemented")

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
