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

function build_lhs!(estimator::UniversalKriging, Γ::AbstractMatrix)
  X = estimator.X; degree = estimator.degree
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

  [Γ F; F' zeros(eltype(Γ), nterms, nterms)]
end

function build_rhs!(estimator::UniversalKriging, g::AbstractVector, xₒ::AbstractVector)
  exponents = estimator.exponents
  nterms = size(exponents, 2)
  f = [prod(xₒ.^exponents[:,j]) for j=1:nterms]

  [g; f]
end
