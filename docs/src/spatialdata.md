# Spatial data

In GeoStats.jl, data and domain are disconnected one from another. This design enables
levels of parallelism that would be difficult or even impossible to implement otherwise.

The data is accessed by solvers only if strictly necessary. One of our goals is to be
able to handle massive datasets that may not fit in random-access memory (RAM).

## GeoDataFrame

For point (or hard) data in spreadsheet format (e.g. CSV, TSV), the `GeoDataFrame` object
is a lightweight wrapper over Julia's `DataFrame` types.

```@docs
GeoDataFrame
```

```@docs
readtable
```

## RegularGridData

In the case that the data is regularly spaced in a grid, the `GeoGridData` object provides
fast access across multiple overlaid images.

```@docs
RegularGridData
```
