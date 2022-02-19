# Domains

## Overview

A geospatial domain is a region in physical space where data
can be measured. For example, a collection of rain gauge stations
can be represented as a point set in the map. Similarly, a collection
of states in a given country can be represented as a set of 2D shapes.

We provide flexible domain types for advanced geospatial workflows via
the [Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl) project.
Please check their documentation for more details.

## Examples

### PointSet

```@example domains
using GeoStats # hide
using Plots # hide
gr(size=(600,600)) # hide

pset = PointSet(rand(3,100))
```

```@example domains
plot(pset, camera=(30,60))
```

### GeometrySet

```@example domains
t = Triangle((0.0,0.0), (1.0,1.0), (0.0,1.0))
q = Quadrangle((1.0,1.0), (2.0,1.0), (2.0,2.0), (1.0,2.0))

gset = GeometrySet([t, q])
```

```@example domains
plot(gset, fillcolor=:gray90, linecolor=:black)
```

### CartesianGrid

```@example domains
grid = CartesianGrid(10,10,10)
```

```@example domains
plot(grid, camera=(30,60))
```

### SimpleMesh

```@example domains
points = Point2[(0,0), (1,0), (0,1), (1,1), (0.25,0.5), (0.75,0.5)]
connec = connect.([(1,5,3),(4,6,2),(1,2,6,5),(4,3,5,6)], Ngon)
mesh   = SimpleMesh(points, connec)
```

```@example domains
plot(mesh, fillcolor=:gray90, linecolor=:black)
```
