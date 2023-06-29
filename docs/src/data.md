# Geospatial data

## Overview

Given a table or array containing data, we can georeference these objects
ono a geospatial domain with the [`georef`](@ref) function. For a list of
available domains, please see [Domains](domains.md).

```@docs
georef
```

In the opposite direction, the functions [`values`](@ref) and
[`domain`](@ref) can be used to retrieve the table of attributes
and the underlying geospatial domain.

```@docs
values
domain
```

The [GeoTables.jl](https://github.com/JuliaEarth/GeoTables.jl) package
can be used to load geospatial data from various file formats. It also
provides utility functions to automatically download maps given the
name of any region in the world.

```@docs
GeoTables.load
GeoTables.save
GeoTables.gadm
```

## Examples

### Tables

Consider a table (e.g. DataFrame) with 25 samples of temperature (T) and
pressure (P):

```@example georef
using DataFrames
using GeoStats # hide
using Plots # hide
using GeoStatsPlots # hide

table = DataFrame(T=rand(25), P=rand(25))
```

We can georeference this table based on a given set of coordinates:

```@example georef
georef(table, PointSet(rand(2,25))) |> plot
```

or alternatively, georeference it on a 5x5 regular grid (5x5 = 25 samples):

```@example georef
georef(table, CartesianGrid(5,5)) |> plot
```

In the first case, the `PointSet` domain type can be omitted, and GeoStats.jl
will understand that the matrix passed as the second argument contains the
coordinates of a point set:

```@example georef
georef(table, rand(2,25))
```

Another common pattern in geospatial data is when the coordinates of the samples
are already part of the table as columns. In this case, we can specify the column
names as symbols:

```@example georef
table = DataFrame(T=rand(25), P=rand(25), X=rand(25), Y=rand(25), Z=rand(25))

georef(table, (:X, :Y, :Z)) |> plot
```

### Arrays

Consider arrays (e.g. images) with data for various geospatial variables. We can
georeference these arrays using a named tuple, and GeoStats.jl will understand
that the shape of the arrays should be preserved in a Cartesian grid:

```@example georef
T, P = rand(5,5), rand(5,5)

georef((T=T, P=P)) |> plot
```

We can also specify the origin and spacing of the grid using keyword arguments:

```@example georef
𝒟₁ = georef((T=T, P=P), origin=(0.,0.), spacing=(1.,1.))
𝒟₂ = georef((T=T, P=P), origin=(10.,10.), spacing=(2.,2.))

plot(𝒟₁)
plot!(𝒟₂)
```

Alternatively, we can interpret the entries of the named tuple as columns in a table:

```@example georef
georef((T=T, P=T), rand(2,25)) |> plot
```

### Files

We can easily load geospatial data from disk without any specific knowledge of file formats:

```@example files
using GeoTables
using GeoStats # hide
using Plots # hide
gr(size=(600,400)) # hide

zone = GeoTables.load("data/zone.shp")
path = GeoTables.load("data/path.shp")

plot(zone.geometry, fill = true, color = :gray)
plot!(path.geometry, fill = true, color = :gray90)
```

## Custom data

GeoStats.jl is integrated with the [Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl)
project. In summary, any type that is a subtype of `Meshes.Data` and that implements
`Meshes.domain` and `Meshes.values` is compatible with the framework and can be used
in geostatistical workflows.

Please ask in our community channel if you need help implementing custom geospatial data.
