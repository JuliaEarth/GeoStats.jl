# Domains

Below is the list of currently implemented domain types.

## PointSet

```@docs
PointSet
```

```@example domains
using GeoStats # hide
using Plots # hide
gr(size=(600,600)) # hide

plot(PointSet(rand(3,100)), camera=(30,60))
```

## RegularGrid

```@docs
RegularGrid
```

```@example domains
plot(RegularGrid{Float64}(10,10,10), camera=(30,60))
```

## StructuredGrid

```@docs
StructuredGrid
```

```@example domains
# create 3D coordinates
nx, ny, nz = 20, 10, 10
X = [x for x in range(0,10,length=nx), j in 1:ny, k in 1:nz]
Y = sin.(X) .+ [0.5j for i in 1:nx, j in 1:ny, k in 1:nz]
Z = [1.0(k-1) for i in 1:nx, j in 1:ny, k in 1:nz]

g = StructuredGrid(X, Y, Z)

plot(g, camera=(30,60))
```
