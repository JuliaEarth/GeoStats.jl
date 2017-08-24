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
    SimpleMapper(geodata, domain, targetvars)

A mapping strategy that maps `targetvars` in `geodata` onto
an arbitrary `domain` using a closest-point algorithm.
"""
struct SimpleMapper{D<:AbstractDomain} <: AbstractMapper{D}
  dict::Dict{Symbol,Dict{Int,<:Any}}

  SimpleMapper{D}(dict) where {D<:AbstractDomain} = new(dict)
end

function SimpleMapper(geodata::GeoDataFrame, domain::D,
                      targetvars::Vector{Symbol}) where {D<:AbstractDomain}
  # retrieve data
  rawdata = data(geodata)
  cnames = coordnames(geodata)

  # build dictionary with mappings
  dict = Dict()
  for var in targetvars
    # retrieve data for variable
    vardata = rawdata[[cnames...,var]]
    completecases!(vardata)

    # determine value type
    V = eltype(rawdata[var])

    # map locations to values
    mapping = Dict{Int,V}()
    for row in eachrow(vardata)
      coords = vec(convert(Array, row[cnames]))
      value  = row[var]

      # find closest point in the domain
      location = findclosest(domain, coords)

      push!(mapping, location => value)
    end

    # save mapping for variable
    push!(dict, var => mapping)
  end

  SimpleMapper{D}(dict)
end

function findclosest(domain::D, coordinates) where {D<:RegularGrid}
  dims = size(domain)
  dorigin = origin(domain)
  dspacing = spacing(domain)

  intcoords = round.(Int, (coordinates .- [dorigin...]) ./ [dspacing...])

  sub2ind(dims, intcoords...)
end

#hasdata(m::SimpleMapper, variable::Symbol, location::I) where {I<:Integer} = location ∈ keys(m.dict[variable])
#getdata(m::SimpleMapper, variable::Symbol, location::I) where {I<:Integer} = m.dict[variable][location]
mapping(m::SimpleMapper, variable::Symbol) = m.dict[variable]
