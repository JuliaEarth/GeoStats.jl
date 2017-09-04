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
    BallNeighborhood(domain, radius)

A ball neighborhood of a given `radius` on a spatial `domain`.
"""
struct BallNeighborhood{D<:AbstractDomain} <: AbstractNeighborhood{D}
  # input fields
  domain::D
  radius # we cannot use coordtype(D) here yet in Julia v0.6

  # state fields
  cube::CubeNeighborhood{D}

  function BallNeighborhood{D}(domain, radius) where D<:AbstractDomain
    @assert radius > 0 "radius must be positive"
    @assert typeof(radius) == coordtype(domain) "radius and domain coordinate type must match"

    # cube of same radius
    cube = CubeNeighborhood(domain, radius)

    new(domain, radius, cube)
  end
end

BallNeighborhood(domain::D, radius) where {D<:AbstractDomain} = BallNeighborhood{D}(domain, radius)

function (neigh::BallNeighborhood{<:RegularGrid})(location::I) where {I<:Integer}
  # retrieve domain
  ndomain = neigh.domain

  # get neighbors in cube of same radius
  cneighbors = neigh.cube(location)

  # coordinates of the center
  xₒ = coordinates(ndomain, location)

  # discard neighbors outside of sphere
  neighbors = I[]
  for neighbor in cneighbors
    x = coordinates(ndomain, neighbor)

    # compute ||x-xₒ||^2
    sum² = zero(eltype(x))
    for i=1:ndims(ndomain)
      sum² += (x[i] - xₒ[i])^2
    end

    sum² ≤ neigh.radius^2 && push!(neighbors, neighbor)
  end

  neighbors
end

function (neigh::BallNeighborhood{<:PointCollection})(location::I) where {I<:Integer}
  # retrieve domain
  ndomain = neigh.domain

  # center in real coordinates
  xₒ = coordinates(ndomain, location)

  neighbors = I[]
  for loc in 1:npoints(ndomain)
    x = coordinates(ndomain, loc)
    norm(x .- xₒ) ≤ neigh.radius && push!(neighbors, loc)
  end

  neighbors
end
