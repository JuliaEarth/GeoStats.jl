# Spatial data

Below is the list of currently implemented spatial data types in the project.

## GeoDataFrame

For point data in spreadsheet format (e.g. CSV, TSV), the `GeoDataFrame`
object is a lightweight wrapper over Julia's `DataFrame` types.

```@docs
GeoDataFrame
```

```@docs
readgeotable
```

## PointSetData

The `PointSetData` object is equivalent to `GeoDataFrame` except that it stores
the data in a Julia `OrderedDict` instead of in a `DataFrame`.

```@docs
PointSetData
```

## RegularGridData

In the case that the data is regularly spaced in a grid, the `RegularGridData`
object provides fast access across multiple overlaid images.

```@docs
RegularGridData
```

## StructuredGridData

A `StructuredGridData` is a direct generalization of `RegularGridData` in which
points can be localized in space with indices `i,j,k...` even though they are not
regularly spaced. This format is often found in satellite data,
[NetCDF](https://en.wikipedia.org/wiki/NetCDF), etc.

```@docs
StructuredGridData
```
