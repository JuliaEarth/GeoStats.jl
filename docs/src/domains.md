# Domains

Although estimators such as Kriging do **not** require equally spaced samples,
many software packages for geostatistical estimation/simulation restrict their
implementations to regular grids. This is a big limitation, however; given that
sampling campaigns and resource exploration is rarely regular.

In GeoStats.jl, estimation/simulation can be performed on arbitrary domain types such
as simple point collections, unstructured meshes, and tesselations. These types are
implemented "analytically" in order to minimize memory access and maximize performance.
In a regular grid, for example, the coordinates of a given location are known, and one
can perform search without ever constructing a grid.

Below is the list of currently implemented domain types. More options will be available
in future releases.

## PointSet

```@docs
PointSet
```

## RegularGrid

```@docs
RegularGrid
```
