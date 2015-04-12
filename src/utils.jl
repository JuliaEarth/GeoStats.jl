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

## Evaluate a metric between all n² pairs of
## columns in a m-by-n matrix efficiently.
function pairwise(metric, X::AbstractMatrix)
    m, n = size(X)
    D = zeros(n, n)
    for j=1:n
        for i=j+1:n
            @inbounds D[i,j] = metric(norm(X[:,i] - X[:,j]))
        end
        @inbounds D[j,j] = metric(0)
        for i=1:j-1
            @inbounds D[i,j] = D[j,i] # leveraging the symmetry
        end
    end

    D
end
