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
    AbstractDomain{N,T}

A spatial domain with `N` dimensions in which
points are represented with coordinates of type `T`.
"""
abstract type AbstractDomain{T<:Real,N} end

"""
    ndims(domain)

Return the number of dimensions of a spatial domain.
"""
Base.ndims(::AbstractDomain{T,N}) where {N,T<:Real} = N

"""
    coordtype(domain)

Return the coordinate type of a spatial domain.
"""
coordtype(::AbstractDomain{T,N}) where {N,T<:Real} = T

"""
    size(domain)

Return the size (a tuple) of a spatial domain.
"""
Base.size(domain::AbstractDomain) = domain.dims

"""
    npoints(domain)

Return the number of points of a spatial domain.
"""
npoints(domain::AbstractDomain) = prod(size(domain))

"""
    coords(domain, location)

Return the coordinates of the `location` in the `domain`.
"""
coordinates(::AbstractDomain, location::I) where {I<:Integer} = error("not implemented")

#------------------
# IMPLEMENTATIONS
#------------------
include("domains/regular_grid.jl")
