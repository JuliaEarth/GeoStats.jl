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

"""
    pairwise(covariance, X)

Evaluate `covariance` between all n² pairs of columns in a m-by-n matrix `X` efficiently.
"""
function pairwise(covariance::Function, X::AbstractMatrix)
  m, n = size(X)
  C = zeros(n, n)
  for j=1:n
    xj = view(X, :, j)
    for i=j+1:n
      xi = view(X, :, i)
      @inbounds C[i,j] = covariance(xi, xj)
    end
    @inbounds C[j,j] = covariance(xj, xj)
    for i=1:j-1
      @inbounds C[i,j] = C[j,i] # leverage the symmetry
    end
  end

  C
end

"""
    EmpiricalDistribution(values)

An empirical distribution holding continuous values.
"""
struct EmpiricalDistribution{T<:Real} <: ContinuousUnivariateDistribution
  values::Vector{T}

  function EmpiricalDistribution{T}(values) where {T<:Real}
    @assert !isempty(values) "values must be non-empty"
    new(sort(values))
  end
end
EmpiricalDistribution(values) = EmpiricalDistribution{eltype(values)}(values)

Distributions.quantile(d::EmpiricalDistribution, p::Real) = quantile(d.values, p, sorted=true)

function Distributions.cdf(d::EmpiricalDistribution{T}, x::T) where {T<:Real}
  v = d.values
  N = length(v)

  head, mid, tail = 1, 1, N
  while tail - head > 1
    mid = (head + tail) ÷ 2
    if x < v[mid]
      tail = mid
    else
      head = mid
    end
  end

  l, u = v[head], v[tail]

  if x < l
    return 0.
  elseif x > u
    return 1.
  else
    if head == tail
      return head / N
    else
      pl, pu = head / N, tail / N
      return (pu - pl) * (x - l) / (u - l) + pl
    end
  end
end

"""
    transform!(samples, origin, target)

Transform `samples` from `origin` distribution to `target` distribution in place.
"""
function transform!(samples::AbstractVector,
                    origin::ContinuousUnivariateDistribution,
                    target::ContinuousUnivariateDistribution)
  for i in eachindex(samples)
    p = cdf(origin, samples[i])
    samples[i] = quantile(target, p)
  end
end
