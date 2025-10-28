# How to work with "rasters"?

```@example rasters
using GeoStats # hide
import CairoMakie as Mke # hide
```

A "raster" is nothing more than a Julia array that is georeferenced over a geospatial grid.
The "raster" model is popular in the scientific community for two main reasons:

1. It provides convenient syntax to access grid elements within "rectangular" regions,
   including syntax to name array dimensions as "x", "y", ... and extract rectangular
   regions based on coordinate values.

2. It can rely on [DiskArrays.jl](https://github.com/JuliaIO/DiskArrays.jl) and similar
   packages for loading large datasets lazily, without consuming all the available RAM.

We illustrate how `GeoTable`s over `Grid`s share these benefits.

## Convenient syntax

### n-dimensional array syntax

Any `GeoTable` over a `Grid` supports the n-dimensional array syntax in the row selector.

Consider the following example from the NaturalEarth dataset:

```@example rasters
using GeoArtifacts

raster = NaturalEarth.naturalearth1("water") |> Upscale(10, 5)

raster |> viewer
```

We can check the size of the underlying grid with

```@example rasters
size(raster.geometry)
```

This dataset is stored with `LatLon` coordinates. For convenience, we always store the
"horizontal" coordinate along the first axis of the grid (longitude in this case). We
can slice the Earth as follows:

```@example rasters
raster[(1:800, :), :] |> viewer
```

```@example rasters
raster[(:, 1:800), :] |> viewer
```

```@example rasters
raster[(:, 500:800), :] |> viewer
```

We can also slice after 2D projections, which is more common in the literature:

```@example rasters
projec = raster |> Proj(Robinson)

projec |> viewer
```

```@example rasters
projec[(300:800, 600:1400), :] |> viewer
```

### `Slice` transform syntax

To select a subset of the dataset from actual coordinate ranges, we can use the `Slice` transform.
To slice the `x` and `y` coordinates of the projected dataset with values in kilometers, we do:

```@example rasters
km = u"km" # define kilometer unit

projec |> Slice(x=(0km, 20000km), y=(0km, 10000km)) |> viewer
```

Notice that the result is no longer a "raster" because the `Robinson` projection deforms the graticule,
and we can’t simply rely on the sorted `x` and `y` coordinates of the first row and column to find indices
across the other rows and columns. Although the result *cannot* be represented with the "raster" model,
it *can* be represented with the `GeoTable` model over a lazy domain view.

The `x` and `y` options can be replaced by `lon` and `lat` if the `crs` of the domain is geographic.
Below is an example of subgrid over the ellipsoid using `lat` and `lon` ranges:

```@example rasters
° = u"°" # define degree unit

brazil = raster |> Slice(lat=(-60°, 20°), lon=(-100°, -20°))

brazil |> Rotate(RotZ(-45)) |> viewer
```

## Lazy loading

The Grid itself is lazy, it doesn’t allocate memory:

```@example rasters
Base.summarysize(raster.geometry)
```

Remember that a n-dimensional array is simply a flat memory buffer with an additional tuple containing
the number of elements along each dimension. In Julia, the `vec` and `reshape` operations are lazy:

```@example rasters
X = rand(1000, 1000)

@allocated vec(X)
```

```@example rasters
@allocated reshape(vec(X), 1000, 1000)
```

If you have a `DiskArray` or any other array type that satisfies your memory requirements, simply `georef`
it over a `Grid` to obtain a "lazy" `GeoTable`:

```@example rasters
georef((; x=vec(X)), CartesianGrid(1000, 1000))
```

The [GeoIO.jl](https://github.com/JuliaEarth/GeoIO.jl) package is highly recommended as it will take care
of these low-level memory details for you.
