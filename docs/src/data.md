# Geospatial data

## Overview

Given a table or array containing data, we can georeference these objects
onto a geospatial [domain](domains.md) with the [`georef`](@ref) function.
The result of the [`georef`](@ref) function is a **GeoTable**. If you would
like to learn this concept in more depth, check out the recording of our
JuliaEO 2024 workshop:

```@raw html
<p align="center">
<iframe style="width:560px;height:315px" src="https://www.youtube.com/embed/r7MwEme_Y5w?si=ZGG_T0kmmKlJcVBl&amp;start=364" title="GeoTables.jl worksthop at JuliaEO 2024" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
</p>
```

```@docs
georef
```

The functions [`values`](@ref) and [`domain`](@ref) can be used to retrieve
the table of attributes and the underlying geospatial domain:

```@docs
values
domain
```

The [GeoIO.jl](https://github.com/JuliaEarth/GeoIO.jl) package can be used
to load/save geospatial data from/to various file formats:

```@docs
GeoIO.load
GeoIO.save
GeoIO.formats
```

The [GeoArtifacts.jl](https://github.com/JuliaEarth/GeoArtifacts.jl) package
provides utility functions to automatically download geospatial data from
repositories on the internet.

## Examples

```@example data
using GeoStats
import CairoMakie as Mke

# helper function for plotting two
# variables named T and P side by side
function plot(data)
  fig = Mke.Figure(size = (800, 400))
  viz(fig[1,1], data.geometry, color = data.T)
  viz(fig[1,2], data.geometry, color = data.P)
  fig
end
```

### Tables

Consider a table (e.g. DataFrame) with 25 samples of temperature `T` and
pressure `P`:

```@example data
using DataFrames

table = DataFrame(T=rand(25), P=rand(25))
```

We can georeference this table based on a given set of points:

```@example data
georef(table, rand(Point, 25)) |> plot
```

or alternatively, georeference it on a 5x5 regular grid (5x5 = 25 samples):

```@example data
georef(table, CartesianGrid(5, 5)) |> plot
```

Another common pattern in geospatial data is when the coordinates of the samples
are already part of the table as columns. In this case, we can specify the column
names:

```@example data
table = DataFrame(T=rand(25), P=rand(25), X=rand(25), Y=rand(25), Z=rand(25))

georef(table, ("X", "Y", "Z")) |> plot
```

### Arrays

Consider arrays (e.g. images) with data for various geospatial variables. We can
georeference these arrays using a named tuple, and the framework will understand
that the shape of the arrays should be preserved in a [`CartesianGrid`](@ref):

```@example data
T, P = rand(5, 5), rand(5, 5)

georef((T=T, P=P)) |> plot
```

Alternatively, we can interpret the entries of the named tuple as columns in a table:

```@example data
georef((T=vec(T), P=vec(P)), rand(Point, 25)) |> plot
```

### Files

We can easily load geospatial data from disk without any specific knowledge of file formats:

```@example data
using GeoIO

zone = GeoIO.load("data/zone.shp")
path = GeoIO.load("data/path.shp")

viz(zone.geometry)
viz!(path.geometry, color = :gray90)
Mke.current_figure()
```