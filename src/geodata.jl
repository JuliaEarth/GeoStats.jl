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
    GeoData(data, coordnames)

A dataframe object `data` with additional metadata for tracking
the columns `coordnames` that represent spatial coordinates.

## Examples

If the data was already loaded in a normal DataFrame `data`,
and there exists columns named `x`, `y` and `z`, wrap the
data and specify the column names:

```julia
julia> GeoData(data, [:x,:y,:z])
```

Alternatively, load the data directly into a `GeoData` object
by using the method [`readtable`](@ref).

### Notes

This type is a lightweight wrapper over Julia's DataFrame types.
No additional storage is required other than a vector of symbols
with the columns names representing spatial coordinates.

"""
struct GeoData{DF<:AbstractDataFrame}
  data::DF
  coordnames::Vector{Symbol}
end

GeoData(data, coordnames) = GeoData{typeof(data)}(data, coordnames)

"""
    readtable(args; coordnames=[:x,:y,:z], kwargs)

Read data from disk using `DataFrames.readtable`, optionally
specifying the columns `coordnames` with spatial coordinates.

The arguments `args` and keyword arguments `kwargs` are
forwarded to the `DataFrames.readtable` function, please
check their documentation for more details.

This function returns a [`GeoData`](@ref) object.
"""
function readtable(args...; coordnames=[:x,:y,:z], kwargs...)
  data = DataFrames.readtable(args...; kwargs...)
  @assert coordnames ⊆ DataFrames.names(data) "coordnames must contain valid column names"

  GeoData(data, coordnames)
end

"""
    names(geodata)

Return the column names of `geodata`.
"""
Base.names(geodata::GeoData) = DataFrames.names(geodata.data)

"""
    coordnames(geodata)

Return the column names of `geodata` representing spatial coordinates.
"""
coordnames(geodata::GeoData) = geodata.coordnames

"""
    coordinates(geodata)

Return the columns of `geodata` representing spatial coordinates.
"""
coordinates(geodata::GeoData) = geodata.data[geodata.coordnames]

"""
    getindex(geodata, colnames)

Return a `GeoData` object with the columns in `colnames` plus the columns
in `geodata` representing spatial coordinates.
"""
Base.getindex(geodata::GeoData, colnames) = begin
  isempty(colnames ∩ geodata.coordnames) || warn("indexing with columns that represent spatial coordinates")
  data = geodata.data[[geodata.coordnames...,colnames...]]
  GeoData(data, geodata.coordnames)
end

"""
    completecases!(geodata)

Delete rows in `geodata` that contain NAs.
"""
completecases!(geodata::GeoData) = DataFrames.completecases!(geodata.data)

# ------------
# IO methods
# ------------
Base.show(io::IO, geodata::GeoData) = begin
  dims = join(size(geodata.data), "×")
  cnames = join(geodata.coordnames, ", ", " and ")
  print(io, "$dims GeoData ($cnames)")
end
