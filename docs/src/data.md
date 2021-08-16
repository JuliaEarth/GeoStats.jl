# Geospatial data

## Overview

Given a table or array containing data, we can georeference these objects
onto a geospatial domain with the [`georef`](@ref) function. For a list of
available domains, please see [Domains](domains.md).

```@docs
georef
```

## Examples

### Tables

Consider a table (e.g. DataFrame) with 25 samples of temperature and
precipitation:

```@example georef
using GeoStats # hide
using DataFrames
using Plots # hide

table = DataFrame(T=rand(25), P=rand(25))
```

We can georeference this table based on a given set of coordinates:

```@example georef
𝒟 = georef(table, PointSet(rand(2,25)))

plot(𝒟)
```

or alternatively, georeference it on a 5x5 regular grid (5x5 = 25 samples):

```@example georef
𝒟 = georef(table, CartesianGrid(5,5))

plot(𝒟)
```

In the first case, the [`PointSet`](@ref) domain type can be omitted, and
GeoStats.jl will understand that the matrix passed as the second argument
contains the coordinates of a point set:


```@example georef
𝒟 = georef(table, rand(2,25))
```

Another common pattern in spatial data sets is when the coordinates of the samples
are already part of the table as columns. In this case, we can specify the column
names as symbols:

```@example georef
table = DataFrame(T=rand(25), P=rand(25), X=rand(25), Y=rand(25), Z=rand(25))

𝒟 = georef(table, (:X,:Y,:Z))

plot(𝒟)
```

### Arrays

Consider arrays (e.g. images) with data for various spatial variables. We can
georeference these arrays using a named tuple, and GeoStats.jl will understand
that the shape of the arrays should be preserved in a Cartesian grid:

```@example georef
T, P = rand(5,5), rand(5,5)

𝒟 = georef((T=T, P=P))

plot(𝒟)
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
𝒟 = georef((T=T, P=T), rand(2,25))

plot(𝒟)
```

### Shapefiles

The [GeoTables.jl](https://github.com/JuliaEarth/GeoTables.jl) package
can be used to load geospatial data from various file formats. It also
provides utility functions to automatically download maps given the
name of any region in the world.

We can load a shapefile as a geospatial table that is compatible with
the GeoStats.jl framework:

```@example shapefile
using GeoTables
using GeoStats # hide
using Plots # hide

zone = GeoTables.load("data/zone.shp")
```

```@example shapefile
path = GeoTables.load("data/path.shp")
```

Unlike in previous examples where each row of the table was associated
with simple geometries (e.g. `Point` or `Quadrangle`), here we have
more complicated geometries to consider:

```@example shapefile
zone.geometry
```

We can visualize these geometries as the domain of the geospatial data
as usual:

```@example shapefile
gr(size=(600,400)) # hide
plot(domain(zone), fill=true, color=:gray)
plot!(domain(path), fill=true, color=:gray90)
```

and most importantly, *nothing special needs to be done*. This geospatial
table can be used with any geostatistical workflow.

## Custom data

GeoStats.jl is integrated with the
[Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl)
project. This means that one can use any `Meshes.Data`
in geostatistical workflows. In summary, any type that
is a subtype of `Meshes.Data` and that implements
`Meshes.domain` and `Meshes.values` is compatible with
the framework.

Please ask in our community channels if you have questions
about custom geospatial data types.
