# Domains

```@example domains
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats # hide
import WGLMakie as Mke # hide
```

## Overview

A geospatial domain is a (discretized) region in physical space.
For example, a collection of rain gauge stations can be represented as a
[`PointSet`](@ref) in the map. Similarly, a collection of states in a given
country can be represented as a [`GeometrySet`](@ref) of polygons.

We provide flexible [`Domain`](@ref) types for advanced geospatial workflows
via the [Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl) submodule.
The domains can consist of sets (or "soups") of geometries as it is most
common in GIS or be actual [`Mesh`](@ref) types with topological information:

```@docs
Domain
Mesh
Grid
```

## Examples

### PointSet

```@docs
PointSet
```

```@example domains
pset = PointSet(rand(3,100))

viz(pset)
```

### GeometrySet

```@docs
GeometrySet
```

```@example domains
tria = Triangle((0.0, 0.0), (1.0, 1.0), (0.0, 1.0))
quad = Quadrangle((1.0, 1.0), (2.0, 1.0), (2.0, 2.0), (1.0, 2.0))
gset = GeometrySet([tria, quad])

viz(gset, showfacets = true)
```

### CartesianGrid

```@docs
CartesianGrid
```

```@example domains
grid = CartesianGrid(10, 10, 10)

viz(grid, showfacets = true)
```

### RectilinearGrid

```@docs
RectilinearGrid
```

```@example domains
x = 0.0:0.2:1.0
y = [0.0, 0.1, 0.3, 0.7, 0.9, 1.0]
grid = RectilinearGrid(x, y)

viz(grid, showfacets = true)
```

### SimpleMesh

```@example domains
points = [(0.0, 0.0), (1.0, 0.0), (0.0, 1.0), (1.0, 1.0), (0.25, 0.5), (0.75, 0.5)]
connec = connect.([(1, 5, 3), (4, 6, 2), (1, 2, 6, 5), (4, 3, 5, 6)])
mesh   = SimpleMesh(points, connec)

viz(mesh, showfacets = true)
```