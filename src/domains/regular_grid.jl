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
    RegularGrid(dims, origin, spacing)
    RegularGrid{T}(dims)

A regular grid with dimensions `dims`, lower left corner at `origin`
and cell spacing `spacing`. The three arguments must have the same length.

In the first constructor, all the arguments are specified as vectors. In
the second constructor, one needs to specify the type of the coordinates
and the dimensions of the grid. In that case, the origin and spacing default
to (0,0,...) and (1,1,...), respectively.

## Examples

Create a 3D regular grid with 100x100x50 locations:

```julia
julia> RegularGrid{Float64}(100,100,50)
```

Create a 2D grid with 100x100 locations and origin at (10.,20.) units:

```julia
julia> RegularGrid([100,100],[10.,20.],[1.,1.])
```

### Notes

Internally, the vectors that are passed as arguments are converted into
tuples that are stored in the stack instead of in the memory heap.
"""
struct RegularGrid{T<:Real,N} <: AbstractDomain{T,N}
  dims::Dims{N}
  origin::NTuple{N,T}
  spacing::NTuple{N,T}

  function RegularGrid{T,N}(dims, origin, spacing) where {N,T<:Real}
    @assert all(dims .> 0) "dimensions must be positive"
    @assert all(spacing .> 0) "spacing must be positive"
    new(dims, origin, spacing)
  end
end

RegularGrid{T}(dims::Dims{N}) where {N,T<:Real} =
  RegularGrid{T,N}(dims, (zeros(T,length(dims))...), (ones(T,length(dims))...))

RegularGrid{T}(dims::Vararg{<:Integer,N}) where {N,T<:Real} = RegularGrid{T}(dims)

RegularGrid(dims::Vector{Int}, origin::Vector{T}, spacing::Vector{T}) where {T<:Real} =
  RegularGrid{T,length(dims)}((dims...), (origin...), (spacing...))

npoints(grid::RegularGrid) = prod(grid.dims)

Base.size(grid::RegularGrid) = grid.dims
origin(grid::RegularGrid) = grid.origin
spacing(grid::RegularGrid) = grid.spacing

function coordinates(grid::RegularGrid, location::I) where {I<:Integer}
  intcoords = ind2sub(grid.dims, location)
  [grid.origin[i] + (intcoords[i] - one(I))*grid.spacing[i] for i=1:ndims(grid)]
end

# ------------
# IO methods
# ------------
function Base.show(io::IO, grid::RegularGrid{T,N}) where {N,T<:Real}
  dims = join(grid.dims, "×")
  print(io, "$dims RegularGrid{$T,$N}")
end

function Base.show(io::IO, ::MIME"text/plain", grid::RegularGrid{T,N}) where {N,T<:Real}
  println(io, "RegularGrid{$T,$N}")
  println(io, "  dimensions: ", grid.dims)
  println(io, "  origin:     ", grid.origin)
  print(  io, "  spacing:    ", grid.spacing)
end
