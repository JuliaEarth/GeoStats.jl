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

abstract AbstractEstimator

@doc doc"""
    fit!(est, X)

  Build covariance of `X` and save factorization in `estimator`.
""" ->
fit!(estimator::AbstractEstimator, X::AbstractMatrix) = error("not implemented")

@doc doc"""
    estimate(est, xₒ)

  Evaluate `estimator` at location `xₒ`
""" ->
estimate(estimator::AbstractEstimator, xₒ::AbstractVector) = error("not implemented")

# Implementations
include("simple_kriging.jl")
include("ordinary_kriging.jl")
include("universal_kriging.jl")
