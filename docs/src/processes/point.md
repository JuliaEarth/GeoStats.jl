# Point processes

```@example pointprocs
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats # hide
import WGLMakie as Mke # hide
```

## Overview

Point processes can be simulated with the function `rand` on
different geometries and domains.

```@docs
Base.rand(::AbstractRNG, ::GeoStatsProcesses.PointProcess, ::Any, ::Int)
```

For example, we can simulate a homogeneous Poisson process
with given intensity over the sphere:

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

The homogeneity property of a point process can be checked
with the [`ishomogeneous`](@ref) function:

```@docs
ishomogeneous
```

Below is the list of currently implemented point processes.

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

The union or (superposition) of two point processes creates a
union process:

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

The [`thin`](@ref) function implements the thinning operation for
point processes and patterns. Below are the available thinning
methods.

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