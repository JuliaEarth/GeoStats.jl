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
    GeoDataFrame(data, coordnames)

A dataframe object `data` with additional metadata for tracking
the columns `coordnames` that represent spatial coordinates.

## Examples

If the data was already loaded in a normal DataFrame `data`,
and there exists columns named `x`, `y` and `z`, wrap the
data and specify the column names:

```julia
julia> GeoDataFrame(data, [:x,:y,:z])
```

Alternatively, load the data directly into a `GeoDataFrame` object
by using the method [`readtable`](@ref).

### Notes

This type is a lightweight wrapper over Julia's DataFrame types.
No additional storage is required other than a vector of symbols
with the columns names representing spatial coordinates.

"""
struct GeoDataFrame{DF<:AbstractDataFrame} <: AbstractSpatialData
  data::DF
  coordnames::Vector{Symbol}

  function GeoDataFrame{DF}(data, coordnames) where {DF<:AbstractDataFrame}
    @assert coordnames ⊆ names(data) "coordnames must contain valid column names"
    new(data, coordnames)
  end
end

GeoDataFrame(data, coordnames) = GeoDataFrame{typeof(data)}(data, coordnames)

"""
    readtable(args; coordnames=[:x,:y,:z], kwargs)

Read data from disk using `DataFrames.readtable`, optionally
specifying the columns `coordnames` with spatial coordinates.

The arguments `args` and keyword arguments `kwargs` are
forwarded to the `DataFrames.readtable` function, please
check their documentation for more details.

This function returns a [`GeoDataFrame`](@ref) object.
"""
function readtable(args...; coordnames=[:x,:y,:z], kwargs...)
  data = DataFrames.readtable(args...; kwargs...)
  GeoDataFrame(data, coordnames)
end

function coordinates(geodata::GeoDataFrame)
  rawdata = geodata.data
  cnames = geodata.coordnames
  ctypes = eltypes(rawdata[cnames])

  Dict(var => T for (var,T) in zip(cnames,ctypes))
end

function variables(geodata::GeoDataFrame)
  rawdata = geodata.data
  cnames = geodata.coordnames
  vnames = [var for var in names(rawdata) if var ∉ cnames]
  vtypes = eltypes(rawdata[vnames])

  Dict(var => T for (var,T) in zip(vnames,vtypes))
end

npoints(geodata::GeoDataFrame) = nrow(geodata.data)

function valid(geodata::GeoDataFrame, var::Symbol)
  rawdata = geodata.data
  cnames = geodata.coordnames

  vardata = rawdata[[cnames...,var]]
  completecases!(vardata)

  X = convert(Array, vardata[cnames])'
  z = convert(Vector, vardata[var])

  X, z
end

# ------------
# IO methods
# ------------
function Base.show(io::IO, geodata::GeoDataFrame)
  dims = join(size(geodata.data), "×")
  cnames = join(geodata.coordnames, ", ", " and ")
  print(io, "$dims GeoDataFrame ($cnames)")
end

function Base.show(io::IO, ::MIME"text/plain", geodata::GeoDataFrame)
  println(io, geodata)
  show(io, geodata.data, true, :Row, false)
end

function Base.show(io::IO, ::MIME"text/html", geodata::GeoDataFrame)
  println(io, geodata)
  show(io, MIME"text/html"(), geodata.data)
end
