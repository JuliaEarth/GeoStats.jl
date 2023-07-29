# Domains

```@example domains
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats # hide
import WGLMakie as Mke # hide
```

## Overview

A geospatial domain is a (discretized) region in physical space with
data measurements. For example, a collection of rain gauge stations
can be represented as a `PointSet` in the map. Similarly, a collection
of states in a given country can be represented as a `GeometrySet` of
polygons.

We provide flexible domain types for advanced geospatial workflows via
the [Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl) project.
Please check out their documentation for more details.

Below is an example of documentation for the [`CartesianGrid`](@ref),
a widely used type of [`Mesh`](@ref):

```@docs
CartesianGrid
Mesh
```

## Examples

### PointSet

```@example domains
pset = PointSet(rand(3,100))

viz(pset)
```

### GeometrySet

```@example domains
tria = Triangle((0.0, 0.0), (1.0, 1.0), (0.0, 1.0))
quad = Quadrangle((1.0, 1.0), (2.0, 1.0), (2.0, 2.0), (1.0, 2.0))
gset = GeometrySet([tria, quad])

viz(gset, showfacets = true)
```

### CartesianGrid

```@example domains
grid = CartesianGrid(10, 10, 10)

viz(grid, showfacets = true)
```

### SimpleMesh

```@example domains
points = [(0.0, 0.0), (1.0, 0.0), (0.0, 1.0), (1.0, 1.0), (0.25, 0.5), (0.75, 0.5)]
connec = connect.([(1,5,3),(4,6,2),(1,2,6,5),(4,3,5,6)])
mesh   = SimpleMesh(points, connec)

viz(mesh, showfacets = true)
```