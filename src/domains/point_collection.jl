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
    PointCollection(coords)

A collection of points with coordinate matrix `coords`.
The number of rows is the dimensionality of the domain
whereas the number of columns is the number of points.
"""
struct PointCollection{T<:Real,N} <: AbstractDomain{T,N}
  coords::AbstractMatrix{T}

  function PointCollection{T,N}(coords) where {N,T<:Real}
    @assert !isempty(coords) "coordinates must be non-empty"
    new(coords)
  end
end

PointCollection(coords::AbstractMatrix{T}) where {T<:Real} =
  PointCollection{T,size(coords,1)}(coords)

npoints(pc::PointCollection) = size(pc.coords, 2)

coordinates(pc::PointCollection, location::I) where {I<:Integer} = pc.coords[:,location]

# ------------
# IO methods
# ------------
function Base.show(io::IO, pc::PointCollection{T,N}) where {N,T<:Real}
  dims = size(pc.coords, 1)
  npts = size(pc.coords, 2)
  print(io, "$dims×$npts PointCollection{$T,$N}")
end

function Base.show(io::IO, ::MIME"text/plain", pc::PointCollection{T,N}) where {N,T<:Real}
  println(io, pc)
  Base.showarray(io, pc.coords, false, header=false)
end
