# Point processes

```@example pointprocs
using GeoStats # hide
import CairoMakie as Mke # hide
```

## Overview

```@docs
Base.rand(::GeoStatsProcesses.PointProcess, ::Any)
```

```@example pointprocs
# geometry of interest
sphere = Sphere((0, 0, 0), 1)

# homogeneous Poisson process
proc = PoissonProcess(5.0)

# sample two point patterns
pset = rand(proc, sphere, 2)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], sphere)
viz!(fig[1,1], pset[1], color = :black)
viz(fig[1,2], sphere)
viz!(fig[1,2], pset[2], color = :black)
fig
```

```@docs
ishomogeneous
```

## Types

```@docs
BinomialProcess
```

```@example pointprocs
# geometry of interest
box = Box((0, 0), (100, 100))

# Binomial process
proc = BinomialProcess(1000)

# sample point patterns
pset = rand(proc, box, 2)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], box)
viz!(fig[1,1], pset[1], color = :black, pointsize = 3)
viz(fig[1,2], box)
viz!(fig[1,2], pset[2], color = :black, pointsize = 3)
fig
```

```@docs
PoissonProcess
```

```@example pointprocs
# geometry of interest
box = Box((0, 0), (100, 100))

# intensity function
λ(p) = sum(coordinates(p))^2 / 10000

# homogeneous process
proc₁ = PoissonProcess(0.5)

# inhomogeneous process
proc₂ = PoissonProcess(λ)

# sample point patterns
pset₁ = rand(proc₁, box)
pset₂ = rand(proc₂, box)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], box)
viz!(fig[1,1], pset₁, color = :black, pointsize = 3)
viz(fig[1,2], box)
viz!(fig[1,2], pset₂, color = :black, pointsize = 3)
fig
```

```@docs
InhibitionProcess
```

```@example pointprocs
# geometry of interest
box = Box((0, 0), (100, 100))

# inhibition process
proc = InhibitionProcess(2.0)

# sample point pattern
pset = rand(proc, box, 2)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], box)
viz!(fig[1,1], pset[1], color = :black, pointsize = 3)
viz(fig[1,2], box)
viz!(fig[1,2], pset[2], color = :black, pointsize = 3)
fig
```

```@docs
ClusterProcess
```

```@example pointprocs
# geometry of interest
box = Box((0, 0), (5, 5))

# Matérn process
proc₁ = ClusterProcess(
  PoissonProcess(1),
  PoissonProcess(1000),
  p -> Ball(p, 0.2)
)

# inhomogeneous parent and offspring processes
proc₂ = ClusterProcess(
  PoissonProcess(p -> 0.1 * sum(coordinates(p) .^ 2)),
  p -> rand(PoissonProcess(x -> 5000 * sum((x - p).^2)), Ball(p, 0.5))
)

# sample point patterns
pset₁ = rand(proc₁, box)
pset₂ = rand(proc₂, box)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], box)
viz!(fig[1,1], pset₁, color = :black, pointsize = 3)
viz(fig[1,2], box)
viz!(fig[1,2], pset₂, color = :black, pointsize = 3)
fig
```

## Operations

```@docs
Base.union(::GeoStatsProcesses.PointProcess, ::GeoStatsProcesses.PointProcess)
```

```@example pointprocs
# geometry of interest
box = Box((0, 0), (100, 100))

# superposition of two Binomial processes
proc₁ = BinomialProcess(500)
proc₂ = BinomialProcess(500)
proc  = proc₁ ∪ proc₂ # 1000 points

pset = rand(proc, box, 2)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], box)
viz!(fig[1,1], pset[1], color = :black, pointsize = 3)
viz(fig[1,2], box)
viz!(fig[1,2], pset[2], color = :black, pointsize = 3)
fig
```

```@docs
thin
RandomThinning
```

```@example pointprocs
# geometry of interest
box = Box((0, 0), (100, 100))

# reduce intensity of Poisson process by half
proc₁ = PoissonProcess(0.5)
proc₂ = thin(proc₁, RandomThinning(0.5))

# sample point patterns
pset₁ = rand(proc₁, box)
pset₂ = rand(proc₂, box)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], box)
viz!(fig[1,1], pset₁, color = :black, pointsize = 3)
viz(fig[1,2], box)
viz!(fig[1,2], pset₂, color = :black, pointsize = 3)
fig
```

```@example pointprocs
# geometry of interest
box = Box((0, 0), (100, 100))

# Binomial process
proc = BinomialProcess(2000)

# sample point pattern
pset₁ = rand(proc, box)

# thin point pattern with probability 0.5
pset₂ = thin(pset₁, RandomThinning(0.5))

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], box)
viz!(fig[1,1], pset₁, color = :black, pointsize = 3)
viz(fig[1,2], box)
viz!(fig[1,2], pset₂, color = :black, pointsize = 3)
fig
```