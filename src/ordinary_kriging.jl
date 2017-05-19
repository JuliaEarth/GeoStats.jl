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

@doc doc"""
    OrdinaryKriging(X, z, cov)

  *INPUTS*:

    * X ∈ ℜ^(mxn) - matrix of data locations
    * z ∈ ℜⁿ      - vector of observations for X
    * cov         - covariance model
""" ->
type OrdinaryKriging{T<:Real,V} <: AbstractEstimator
  # input fields
  X::AbstractMatrix{T}
  z::AbstractVector{V}
  cov::CovarianceModel

  # state fields
  LU::Base.LinAlg.Factorization{T}

  function OrdinaryKriging(X, z, cov)
    @assert size(X, 2) == length(z) "incorrect data configuration"
    OK = new(X, z, cov)
    fit!(OK, X, z)
    OK
  end
end

OrdinaryKriging(X, z, cov) = OrdinaryKriging{eltype(X),eltype(z)}(X, z, cov)

function fit!{T<:Real,V}(estimator::OrdinaryKriging{T,V}, X::AbstractMatrix{T}, z::AbstractVector{V})
  estimator.X = X
  estimator.z = z
  nobs = size(X,2)
  C = pairwise(estimator.cov, X)
  A = [C ones(nobs); ones(nobs)' 0]
  estimator.LU = lufact(A)
end

function estimate{T<:Real,V}(estimator::OrdinaryKriging{T,V}, xₒ::AbstractVector{T})
  X = estimator.X; z = estimator.z; cov = estimator.cov
  LU = estimator.LU
  nobs = length(z)

  # evaluate covariance at location
  c = Float64[cov(norm(X[:,j]-xₒ)) for j=1:nobs]

  # solve linear system
  b = [c; 1]
  λ = LU \ b

  # return estimate and variance
  z⋅λ[1:nobs], cov(0) - b⋅λ
end
