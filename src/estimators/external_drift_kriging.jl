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

function build_lhs!(estimator::ExternalDriftKriging, Γ::AbstractMatrix)
  X = estimator.X; drifts = estimator.drifts
  dim, nobs = size(X)
  ndrifts = length(drifts)

  # polynomial drift matrix
  F = [m(X[:,i]) for i=1:nobs, m in drifts]

  [Γ F; F' zeros(eltype(Γ), ndrifts, ndrifts)]
end

function build_rhs!(estimator::ExternalDriftKriging, g::AbstractVector, xₒ::AbstractVector)
  f = [m(xₒ) for m in estimator.drifts]
  [g; f]
end

function combine(estimator::ExternalDriftKriging{T,V},
                 weights::Weights, z::AbstractVector) where {T<:Real,V}
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
