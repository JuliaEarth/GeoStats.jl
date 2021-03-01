# Domains

Below is the list of currently implemented domain types from
[Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl)

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

## CartesianGrid

```@docs
CartesianGrid
```

```@example domains
plot(CartesianGrid(10,10,10), camera=(30,60))
```
