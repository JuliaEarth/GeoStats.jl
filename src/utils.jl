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
    pairwise(metric, X)

Evaluate `metric` between all n² pairs of columns in a m-by-n matrix `X` efficiently.
"""
function pairwise(metric::Function, X::AbstractMatrix)
  m, n = size(X)
  D = zeros(n, n)
  for j=1:n
    for i=j+1:n
      @inbounds D[i,j] = metric(X[:,i], X[:,j])
    end
    @inbounds D[j,j] = metric(X[:,j], X[:,j])
    for i=1:j-1
      @inbounds D[i,j] = D[j,i] # leveraging the symmetry
    end
  end

  D
end


"""
    multinom_exp(m, n, sortdir=nothing)

Returns the exponents in the multinomial expansion (x₁ + x₂ + ... + xₘ)ⁿ.

For example, the expansion (x₁ + x₂ + x₃)² = x₁² + x₁x₂ + x₁x₃ + ...
has the exponents:

    multinom_exp(3,2)

    6x3 Array{Int64,2}:
     2  0  0
     1  1  0
     1  0  1
     0  2  0
     0  1  1
     0  0  2

The argument `sortdir` can be "ascend" or "descend" for sorted output.
"""
function multinom_exp(m::Integer, n::Integer; sortdir=nothing)
  @assert m > 0 && n ≥ 0
  @assert sortdir in [nothing, "ascend", "descend"]

  # standard stars and bars
  nsymbols = m+n-1
  stars = hcat(combinations(1:nsymbols, n)...)

  # stars minus their consecutive position becomes their index
  idx = broadcast(-, stars, [0:n-1;])

  # accumulate at index position
  result = zeros(Int, m, size(idx,2))
  for i=1:size(idx,1), j=1:size(idx,2)
    result[idx[i,j],j] += 1
  end

  # sort exponents if necessary
  if sortdir ≠ nothing
    sorted = sortperm(vec(maximum(result, 1)), rev=(sortdir=="descend"))
    result = result[:,sorted]
  end

  result'
end
