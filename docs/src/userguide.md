# User guide

This guide provides an overview of a simple geostatistical workflow, which consists of
of three basic steps:

1. Manipulation of spatial data
2. Definition of geostatistical problem
3. Visualization of problem solution

These steps are only shown to guide the reader, which is free to follow his/her own workflow.

For more detailed tutorials, please check the [Tutorials](tutorials.md) section of the
documentation.

## Manipulating data

The workflow starts with the creation of spatial data objects, which can be loaded from
disk or derived from other Julia variables. For example, given a Julia array (or image),
which is not attached to any particular coordinate system:

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

The origin and spacing of samples in the regular grid can be specified in the constructor:

```@example userguide
RegularGridData(Dict(:Z=>Z), (1.,1.), (10.,10.))
```

and different spatial data types have different constructor options (see [Data](data.md) for more options).

We plot the spatial data and note a few differences compared to the image plot shown above:

```@example userguide
plot(sdata)
```

First, we note that the image was rotated to match the first index `i` of the array
with the horizontal "x" axis, and the second index `j` of the array with the vertical
"y" axis. Second, we note that the image was stretched to reflect the real `100x200`
size of the regular grid data.

Each sample in the spatial data object has a coordinate, which is calculated on demand
for a given list of locations (i.e. spatial indices):

```@example userguide
coordinates(sdata, 1:3)
```

In-place versions exist to avoid unnecessary memory allocations.

All coordinates are retrieved as a `ndims x npoints` matrix when we do not specify
the spatial indices:

```@example userguide
coordinates(sdata)
```

### Tabular access

Spatial data types implement the [Tables.jl](https://github.com/JuliaData/Tables.jl)
interface, which means that they can be accessed as if they were tables with samples
in the rows and variables in the columns:

```@example userguide
sdata[1:3,:Z]
```

In this case, the coordinates of the samples are lost. To reconstruct a spatial data
object, we need to save the spatial indices that were used to index the table:

```@example userguide
zvals = sdata[1:3,:Z]
coord = coordinates(sdata, 1:3)

PointSetData(Dict(:Z=>zvals), coord)
```

To recover the original Julia array behind a spatial data object, we can index the
data with the variable name. In this case, the size of the array (i.e. `100x200`)
is preserved:

```@example userguide
sdata[:Z]
```

### Spatial views

Spatial data types can be viewed at a subset of locations without unnecessary
memory allocations. Spatial views do not preserve the spatial regularity of the
data in general.

By plotting a view of the first 10 lines of our regular grid data, we obtain a
general `PointSetData` as opposed to a `RegularGridData`:

```@example userguide
sview = view(sdata, 1:10*100)
plot(sview)
```

We plot a random view of the grid to emphasize that views do not preserve
spatial regularity:

```@example userguide
inds = rand(1:npoints(sdata), 100)
plot(view(sdata, inds))
```

### Data partitions

Spatial data objects can be partitioned with various efficient methods.
To demonstrate the operation, we partition our spatial data view into
balls of given radius:

```@example userguide
p = partition(sview, BallPartitioner(5.))
plot(p)
```

or, alternatively, into two halfspaces:

```@example userguide
p = partition(sview, BisectFractionPartitioner((1.,1.), 0.5))
plot(p)
```

Spatial partitions are (lazy) iterators of spatial views, which are useful in
many contexts as it will be shown in the next section of the user guide. To
access a subset of a partition, we use index notation:

```@example userguide
plot(p[1])
```

```@example userguide
plot(p[2])
```

## Defining problems

## Plotting solutions
