# Domains

```@example domains
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide
```

## Overview

A geospatial domain is a region in physical space where data
can be measured. For example, a collection of rain gauge stations
can be represented as a point set in the map. Similarly, a collection
of states in a given country can be represented as a set of 2D shapes.

We provide flexible domain types for advanced geospatial workflows via
the [Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl) project.
Please check their documentation for more details.

## Examples

```@example domains
using GeoStats, GeoStatsViz
import WGLMakie as Mke
```

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