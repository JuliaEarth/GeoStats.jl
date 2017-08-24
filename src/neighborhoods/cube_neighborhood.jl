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
    CubeNeighborhood(domain, side)

A cube neighborhood with a given `side` on a spatial `domain`.
"""
struct CubeNeighborhood{D<:AbstractDomain} <: AbstractNeighborhood{D}
  domain::D
  side # we cannot use coordtype(D) here yet in Julia v0.6

  function CubeNeighborhood{D}(domain, side) where {D<:AbstractDomain}
    @assert side > 0 "cube side must be positive"
    @assert typeof(side) == coordtype(domain) "radius and domain coordinate type must match"

    new(domain, side)
  end
end

CubeNeighborhood(domain::D, side) where {D<:AbstractDomain} = CubeNeighborhood{D}(domain, side)

function (neigh::CubeNeighborhood{<:RegularGrid})(location::I) where {I<:Integer}
  # grid size
  sz = size(neigh.domain)

  # cube center in multi-dimensional index format
  center = [ind2sub(sz, location)...]

  # number of units to reach the sides of the cube
  units = floor.(Int, (neigh.side ./ 2) ./ [spacing(neigh.domain)...])

  # cube spans from top left to bottom right
  topleft     = max.(center .- units, 1)
  bottomright = min.(center .+ units, [sz...])

  istart = CartesianIndex(tuple(topleft...))
  iend   = CartesianIndex(tuple(bottomright...))
  cartesian_range = CartesianRange(istart, iend)

  # pre-allocate memory
  neighbors = Vector{I}(length(cartesian_range))

  for (i,idx) in enumerate(cartesian_range)
    neighbors[i] = sub2ind(sz, idx.I...)
  end

  neighbors
end
