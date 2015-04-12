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

include("covmodels.jl")
include("utils.jl")

using CovarianceModel: gaussian

## 2nd-order stationary Kriging
##
## Polyalgorithm for 2nd-order stationary Kriging.
## If μ is nothing, Ordinary Kriging is performed,
## otherwise, Simple Kriging is triggered with μ
## as the constant mean for the random field.
##
##   x₀ ∈ ℜᵐ      - estimation location
##   X  ∈ ℜ^(mxn) - matrix of data locations
##   z  ∈ ℜⁿ      - vector of observations for X
##   μ  ∈ ℜ       - mean of z (or nothing)
##   cov          - covariance model (default to Gaussian)
##
## The algorithm returns the estimate at x₀ and
## the associated estimation variance.
##
## References
## ----------
## OLEA, R. A., 1999. Geostatistics for Engineers
## and Earth Scientists.
function kriging(x₀, X, z; μ=nothing, cov=gaussian)
    @assert size(X) == (length(x₀), length(z))

    n = length(z)
    C = pairwise(cov, X)
    c = Float64[cov(norm(X[:,j]-x₀)) for j=1:n]

    if μ ≠ nothing              # Simple Kriging
        y = z - μ
        λ = C \ c

        # estimate and variance
        μ + y'λ, cov(0) - c'λ
    else                        # Ordinary Kriging
        C = [C ones(n); ones(n)' 0]
        c = [c; 1]
        λ = C \ c

        # estimate and variance
        z'λ[1:n], cov(0) - c'λ
    end
end
