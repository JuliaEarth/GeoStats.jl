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

build_lhs!(estimator::SimpleKriging, Γ::AbstractMatrix) = Γ
build_rhs!(estimator::SimpleKriging, g::AbstractVector, xₒ::AbstractVector) = g

factorize(estimator::SimpleKriging, LHS::AbstractMatrix) = cholfact(LHS)

function combine(estimator::SimpleKriging{T,V},
                 weights::Weights, z::AbstractVector) where {T<:Real,V}
  γ = estimator.γ
  μ = estimator.μ
  b = estimator.RHS
  λ = weights.λ
  y = z - μ

  μ + y⋅λ, γ.sill - b⋅λ
end
