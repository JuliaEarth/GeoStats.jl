# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    ExternalDriftKriging(X, z, γ, drifts)

## Parameters

* X ∈ ℜ^(mxn) - matrix of data locations
* z ∈ ℜⁿ      - vector of observations for X
* γ           - variogram model
* drifts      - vector of external drift functions m: ℜᵐ ↦ ℜ

### Notes

* External drift functions should be smooth
* Kriging system with external drift is often unstable
* Include a constant drift (e.g. `x->1`) for unbiased estimation
* [`OrdinaryKriging`](@ref) is recovered for `drifts = [x->1]`
* For polynomial mean, see [`UniversalKriging`](@ref)
"""
mutable struct ExternalDriftKriging{T<:Real,V} <: AbstractEstimator
  # input fields
  γ::AbstractVariogram
  drifts::Vector{Function}

  # state fields
  X::Matrix{T}
  z::Vector{V}
  LHS::LinAlg.Factorization
  RHS::Vector

  function ExternalDriftKriging{T,V}(γ, drifts; X=nothing, z=nothing) where {T<:Real,V}
    EDK = new(γ, drifts)
    if X ≠ nothing && z ≠ nothing
      fit!(EDK, X, z)
    end

    EDK
  end
end

ExternalDriftKriging(X, z, γ, drifts) = ExternalDriftKriging{eltype(X),eltype(z)}(γ, drifts, X=X, z=z)

function add_constraints_lhs!(estimator::ExternalDriftKriging, Γ::AbstractMatrix)
  X = estimator.X; drifts = estimator.drifts
  dim, nobs = size(X)
  ndrifts = length(drifts)

  # polynomial drift matrix
  F = [m(X[:,i]) for i=1:nobs, m in drifts]

  estimator.LHS = lufact([Γ F; F' zeros(eltype(Γ), ndrifts, ndrifts)])

  nothing
end

function add_constraints_rhs!(estimator::ExternalDriftKriging, xₒ::AbstractVector)
  drifts = estimator.drifts
  nobs = size(estimator.X, 2)

  RHS = estimator.RHS
  for (j, m) in enumerate(drifts)
    RHS[nobs+j] = m(xₒ)
  end

  nothing
end
