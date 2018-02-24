# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    UniversalKriging(X, z, γ, degree)

## Parameters

* X ∈ ℜ^(mxn) - matrix of data locations
* z ∈ ℜⁿ      - vector of observations for X
* γ           - variogram model
* degree      - polynomial degree for the mean

### Notes

* [`OrdinaryKriging`](@ref) is recovered for 0th degree polynomial
* For non-polynomial mean, see [`ExternalDriftKriging`](@ref)
"""
mutable struct UniversalKriging{T<:Real,V} <: AbstractEstimator
  # input fields
  γ::AbstractVariogram
  degree::Int

  # state fields
  X::Matrix{T}
  z::Vector{V}
  LHS::LinAlg.Factorization
  RHS::Vector
  exponents::Matrix{Int}

  function UniversalKriging{T,V}(γ, degree; X=nothing, z=nothing) where {T<:Real,V}
    @assert degree ≥ 0 "degree must be nonnegative"
    UK = new(γ, degree)
    if X ≠ nothing && z ≠ nothing
      fit!(UK, X, z)
    end

    UK
  end
end

UniversalKriging(X, z, γ, degree) = UniversalKriging{eltype(X),eltype(z)}(γ, degree, X=X, z=z)

function add_constraints_lhs!(estimator::UniversalKriging, Γ::AbstractMatrix)
  X = estimator.X
  degree = estimator.degree
  dim, nobs = size(X)

  # multinomial expansion
  expmats = [hcat(collect(multiexponents(dim, d))...) for d in 0:degree]
  exponents = hcat(expmats...)

  # sort expansion for better conditioned Kriging matrices
  sorted = sortperm(vec(maximum(exponents, 1)), rev=true)
  exponents = exponents[:,sorted]

  # update object field
  estimator.exponents = exponents

  # polynomial drift matrix
  nterms = size(exponents, 2)
  F = [prod(X[:,i].^exponents[:,j]) for i=1:nobs, j=1:nterms]

  estimator.LHS = lufact([Γ F; F' zeros(eltype(Γ), nterms, nterms)])

  nothing
end

function add_constraints_rhs!(estimator::UniversalKriging, xₒ::AbstractVector)
  exponents = estimator.exponents
  nterms = size(exponents, 2)
  nobs = size(estimator.X, 2)

  RHS = estimator.RHS
  for j in 1:nterms
    RHS[nobs+j] = prod(xₒ.^exponents[:,j])
  end

  nothing
end
