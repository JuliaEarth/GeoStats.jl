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
    AbstractSpatialData

A container with spatial data.
"""
abstract type AbstractSpatialData end

"""
    data(spatialdata)

Return the underlying data wrapped in `spatialdata`.
"""
data(::AbstractSpatialData) = error("not implemented")

"""
    coordnames(spatialdata)

Return the names of the coordinates in `spatialdata`.
"""
coordnames(::AbstractSpatialData) = error("not implemented")

"""
    coordinates(spatialdata)

Return the coordinates of `spatialdata`.
"""
coordinates(::AbstractSpatialData) = error("not implemented")

"""
    npoints(spatialdata)

Return the number of points in `spatialdata`.
"""
npoints(::AbstractSpatialData) = error("not implemented")

#------------------
# IMPLEMENTATIONS
#------------------
include("spatialdata/geodataframe.jl")
