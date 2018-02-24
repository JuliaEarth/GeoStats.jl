# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    OrdinaryKriging(X, z, γ)

## Parameters

* X ∈ ℜ^(mxn) - matrix of data locations
* z ∈ ℜⁿ      - vector of observations for X
* γ           - variogram model
"""
mutable struct OrdinaryKriging{T<:Real,V} <: AbstractEstimator
  # input fields
  γ::AbstractVariogram

  # state fields
  X::Matrix{T}
  z::Vector{V}
  LHS::LinAlg.Factorization
  RHS::Vector

  function OrdinaryKriging{T,V}(γ; X=nothing, z=nothing) where {T<:Real,V}
    OK = new(γ)
    if X ≠ nothing && z ≠ nothing
      fit!(OK, X, z)
    end

    OK
  end
end

OrdinaryKriging(X, z, γ) = OrdinaryKriging{eltype(X),eltype(z)}(γ, X=X, z=z)

function add_constraints_lhs!(estimator::OrdinaryKriging, Γ::AbstractMatrix)
  T = eltype(Γ); n = size(Γ, 1)
  a = ones(T, n); b = zero(T)
  estimator.LHS = lufact([Γ a; a' b])

  nothing
end

function add_constraints_rhs!(estimator::OrdinaryKriging, xₒ::AbstractVector)
  RHS = estimator.RHS
  RHS[end] = one(eltype(RHS))

  nothing
end
