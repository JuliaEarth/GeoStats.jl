# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

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
  X::Matrix{T}
  z::Vector{V}
  LHS::LinAlg.Factorization
  RHS::Vector

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

function add_constraints_lhs!(estimator::SimpleKriging, Γ::AbstractMatrix)
  estimator.LHS = cholfact(Γ)
  nothing
end

add_constraints_rhs!(estimator::SimpleKriging, xₒ::AbstractVector) = nothing

function combine(estimator::SimpleKriging{T,V},
                 weights::Weights, z::AbstractVector) where {T<:Real,V}
  γ = estimator.γ
  μ = estimator.μ
  b = estimator.RHS
  λ = weights.λ
  y = z - μ

  μ + y⋅λ, γ.sill - b⋅λ
end
