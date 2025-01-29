# Domains

```@example domains
using GeoStats # hide
import CairoMakie as Mke # hide
```

## Overview

A geospatial domain is a (discretized) region in physical space.
For example, a collection of rain gauge stations can be represented as a
[`PointSet`](@ref) in the map. Similarly, a collection of states in a given
country can be represented as a [`GeometrySet`](@ref) of polygons.

We provide flexible domain types for advanced geospatial workflows via the
[Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl) submodule. The domains
can consist of sets (or "soups") of geometries as it is most common in GIS or
be actual meshes with topological information.

```@docs
Domain
Mesh
```

The list of supported domains is continuously growing. The following
code can be used to print an updated list in any project environment:

```@example domains
# packages to print type tree
using InteractiveUtils
using AbstractTrees

# load framework's domains
using GeoStats

# define the tree of types
AbstractTrees.children(T::Type) = subtypes(T)

# print all currently available transforms
AbstractTrees.print_tree(Domain)
```

## Examples

### PointSet

```@docs
PointSet
```

```@example domains
pset = PointSet(rand(Point, 100))

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

viz(gset, showsegments = true)
```

### RegularGrid

```@docs
RegularGrid
CartesianGrid
```

```@example domains
grid = CartesianGrid(10, 10, 10)

viz(grid, showsegments = true)
```
