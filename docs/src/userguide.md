# User guide

## Manipulating data

The GeoStats.jl framework defines various spatial data types (see [Data](data.md))
and operations that preserve the coordinates of the samples in a coordinate reference
system (CRC). A geostatistical workflow usually starts with the creation of spatial
data objects, which can be loaded from disk or derived from other Julia variables.

For example, given a Julia array (or image), which is not attached to any particular
coordinate system:

```@example userguide
using Plots

Z = [10sin(i/10) + j for i in 1:100, j in 1:200]

heatmap(Z, c=:bluesreds)
```

we can georeference the image as `RegularGridData`:

```@example userguide
using GeoStats

sdata = RegularGridData{Float64}(Dict(:Z=>Z))
```

The origin and spacing of samples in the regular grid can be specified
in the constructor:

```@example userguide
RegularGridData(Dict(:Z=>Z), (1.,1.), (10.,10.))
```

and different spatial data types have different constructor options.

We can plot the spatial data and note a few differences compared to the
image plot shown above:

```@example userguide
plot(sdata)
```

First, we note that the image was rotated to match the first index of the array "i"
with the horizontal "x" axis, and the second index "j" with the vertical "y" axis.
Second, we note that the image was stretched to reflect the real 100x200 size of
the regular grid data.

Each sample in the spatial data type has a coordinate, which is calculated on the
fly for a given list of locations:

```@example userguide
coordinates(sdata, 1:3)
```

In-place versions exist to avoid unnecessary memory allocations.

### Tabular access

Spatial data types implement the [Tables.jl](https://github.com/JuliaData/Tables.jl)
interface, which means that they can be accessed as if they were tables with samples
in the rows and variables in the columns:

```@example userguide
sdata[1:3,:Z]
```

Additionally, we can recover the original Julia array behind the spatial data
by indexing the data with the variable name. The size of the array, in this
case a 100x200 matrix, is preserved whenever possible:

```@example userguide
sdata[:Z]
```

### Spatial views

Spatial data types can be viewed at a subset of locations without unnecessary
memory allocations. Spatial views do not preserve the spatial regularity property
of the data in general.

By plotting a view of the first 10 lines of our regular grid data, we obtain a
general `PointSetData` as opposed to a `RegularGridData`:

```@example userguide
sview = view(sdata, 1:10*100)
plot(sview)
```

Alternatively, we can plot a random view of the grid to emphasize that views do
not preserve spatial regularity:

```@example userguide
inds = rand(1:npoints(sdata), 100)
plot(view(sdata, inds))
```

### Data partitions

A very common operation in spatial statistics is partitioning. Various partitioning
methods are available. We can for example partition the regular grid data into balls
of given radius:

```@example userguide
p = partition(sview, BallPartitioner(5.))
plot(p)
```

or partition the data based on a bisection plane:

```@example userguide
p = partition(sview, BisectFractionPartitioner((1.,1.), 0.5))
plot(p)
```

Spatial partitions are lazy iterators of spatial views. We can
access the subsets of a partition by indexing it:

```@example userguide
plot(p[1])
```

```@example userguide
plot(p[2])
```

## Defining problems

## Plotting solutions
