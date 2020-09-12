# Spatial data

## Overview

Given a table or array containing data, we can gereference these objects
onto a spatial domain with the [`georef`](@ref) function. For a list of
available spatial domains, please see [Domains](domains.md).

```@docs
georef
```

## Examples

### Tables

Consider a table (e.g. DataFrame) with 25 samples of temperature and
precipitation:

```@example georef
using GeoStats #hide
using DataFrames
using Plots #hide

table = DataFrame(T=rand(25), P=rand(25))
```

We can georeference this table based on a given set of coordinates:

```@example georef
𝒟 = georef(table, PointSet(rand(2,25)))

plot(𝒟)
```

or alternatively, georeference it on a 5x5 regular grid (5x5 = 25 samples):

```@example georef
𝒟 = georef(table, RegularGrid(5,5))

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
that the shape of the arrays should be preserved in a regular grid:

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

## Custom data

GeoStats.jl introduces a set of traits that developers can implement to integrate
their own spatial data and domain types into the framework. These "geotraits" as
we call them live in GeoStatsBase.jl.

To implement a spatial data type compatible with the project, the developer can
inherit basic behavior from [`GeoStatsBase.AbstractData`](@ref), and implement
two functions:

```@docs
GeoStatsBase.domain
GeoStatsBase.values
```

The [`domain`](@ref) function should return the underlying spatial domain where the
data lives. This spatial domain should implement a set of traits for a general finite
element mesh.

The [`values`](@ref) function should return a table according to the Tables.jl interface.
