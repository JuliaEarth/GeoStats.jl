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
    SimpleMapper(spatialdata, domain, targetvars)

A mapping strategy that maps `targetvars` in `spatialdata`
onto an arbitrary `domain` using a closest-point algorithm.
"""
struct SimpleMapper{D<:AbstractDomain} <: AbstractMapper{D}
  dict::Dict{Symbol,Dict{Int,<:Any}}

  SimpleMapper{D}(dict) where {D<:AbstractDomain} = new(dict)
end

function SimpleMapper(spatialdata::S, domain::D, targetvars::Dict{Symbol,DataType}
                     ) where {S<:AbstractSpatialData,D<:AbstractDomain}
  # build dictionary with mappings
  dict = Dict()
  for (var,V) in targetvars
    # retrieve data for variable
    X, z = valid(spatialdata, var)

    # map locations to values
    mapping = Dict{Int,eltype(z)}()
    for j=1:size(X,2)
      coords = view(X, :, j)
      value  = z[j]

      # find closest point in the domain
      location = findclosest(domain, coords)

      1 ≤ location ≤ npoints(domain) && push!(mapping, location => value)
    end

    # save mapping for variable
    push!(dict, var => mapping)
  end

  SimpleMapper{D}(dict)
end

function findclosest(domain::D, coords::AbstractVector{T}) where {T<:Real,D<:RegularGrid{T}}
  dims = size(domain)
  dorigin = origin(domain)
  dspacing = spacing(domain)

  units = round.(Int, (coords .- [dorigin...]) ./ [dspacing...])
  intcoords = ones(Int, ndims(domain)) .+ units

  sub2ind(dims, intcoords...)
end

function findclosest(domain::D, coords::AbstractVector{T}) where {T<:Real,D<:PointCollection{T,<:Any}}
  indmin(norm(coords .- coordinates(domain, loc)) for loc in 1:npoints(domain))
end

mapping(m::SimpleMapper, variable::Symbol) = m.dict[variable]
