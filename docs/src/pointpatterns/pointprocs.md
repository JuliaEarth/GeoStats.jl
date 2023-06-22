# Processes

```@example pointpatterns
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats, GeoStatsViz # hide
import WGLMakie as Mke # hide
```

Point processes can be simulated with the function `rand` on
different geometries and domains:

```@docs
Base.rand(::AbstractRNG, ::PointProcess, ::Any, ::Int)
```

For example, we can simulate a Poisson process with
given intensity in a box:

```@example pointpatterns
# geometry of interest
box = Box((0, 0), (100, 100))

# intensity function
λ(p) = sum(coordinates(p))^2 / 10000

# homogeneous process
proc₁ = PoissonProcess(0.5)

# inhomogeneous process
proc₂ = PoissonProcess(λ)

pset₁ = rand(proc₁, box)
pset₂ = rand(proc₂, box)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], box)
viz!(fig[1,1], pset₁, color = :black, pointsize = 3)
viz(fig[1,2], box)
viz!(fig[1,2], pset₂, color = :black, pointsize = 3)
fig
```

or the superposition of two Binomial processes:

```@example pointpatterns
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

The homogeneity property of a point process can be checked
with the `ishomogeneous` function:

```@docs
ishomogeneous
```

Below is the list of currently implemented point processes.

## BinomialProcess

```@docs
BinomialProcess
```

## PoissonProcess

```@docs
PoissonProcess
```