# Operations

```@example pointops
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats, GeoStatsViz # hide
import WGLMakie as Mke # hide
```

Below is the list of currently implemented operations for point
processes and patterns.

## Superposition

The union or (superposition) of two point processes creates a
union process:

```@docs
Base.union(::PointProcess, ::PointProcess)
```

```@example pointops
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

## Thinning

The [`thin`](@ref) function implements the thinning operation for
point processes and patterns. Below are the available thinning
methods.

```@docs
thin
RandomThinning
```

```@example pointops
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

```@example pointops
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