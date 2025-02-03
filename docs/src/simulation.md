# Simulation

```@example simulation
using GeoStats # hide
import CairoMakie as Mke # hide
```

## Overview

Geostatistical simulation is a powerful alternative to geostatistical
[interpolation](interpolation.md) that preserves local features observed
in the physical world. Instead of a single smoothed map, geostatistical
simulation can produce hundreds of alternative maps (a.k.a. *realizations*)
that honor the observed values stored in a geotable.

In the following sections, we assume some basic understanding of geospatial
random processes. For the purposes of this documentation, we divide these
processes into processes over a known (and fixed) domain, that we call
*field processes*, and processes that simulate the domain itself, where
the most prominent example are *point processes*.

## Field processes

```@docs
GeoStatsProcesses.FieldProcess
Base.rand(::GeoStatsProcesses.FieldProcess, ::Domain, ::Any, ::Any)
```

Realizations of a field process are efficiently stored in an `Ensemble`.
For most purposes, an ensemble is an indexable collection of geotables
together with a few summary statistics that can be used quantify
uncertainty (e.g., `mean`, `var`, `cdf`, `quantile`).

The simulation of field processes can be performed without a geotable in an
*unconditional* simulation. If a geotable is provided, the observed values
are honored in a *conditional* simulation.

We illustrate these concepts with the [`GaussianProcess`](@ref):

```@example simulation
# domain of simulation
grid = CartesianGrid(100, 100)

# field process
proc = GaussianProcess(GaussianVariogram(range=30.0))

# perform simulation
real = rand(proc, grid, [:z => Float64], 100)
```

The first two realizations of the process are shown below:

```@example simulation
fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].z)
viz(fig[1,2], real[2].geometry, color = real[2].z)
fig
```

Likewise, we can show the mean and variance of the ensemble:

```@example simulation
m, v = mean(real), var(real)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], m.geometry, color = m.z)
viz(fig[1,2], v.geometry, color = v.z)
fig
```

or the 25th and 75th percentiles:

```@example simulation
q25 = quantile(real, 0.25)
q75 = quantile(real, 0.75)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], q25.geometry, color = q25.z)
viz(fig[1,2], q75.geometry, color = q75.z)
fig
```

or the cummulative distribution:

```@example simulation
p25 = cdf(real, 0.25)
p75 = cdf(real, 0.75)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], p25.geometry, color = p25.z)
viz(fig[1,2], p75.geometry, color = p75.z)
fig
```

!!! note

    Please check [this page](fieldprocs.md) for more examples.

#### Parallel simulation

All field processes support distributed parallel simulation
with multiple Julia worker processes. Doing so requires using the
[Distributed](https://docs.julialang.org/en/v1/stdlib/Distributed/)
standard library, like in the following example:

```julia
using Distributed

# request additional processes
addprocs(3)

# load code on every single process
@everywhere using GeoStats

# setup simulation
grid = CartesianGrid(100, 100)
proc = GaussianProcess(GaussianVariogram(range=30.0))

# perform simulation on all worker processes
real = rand(proc, grid, [:z => Float64], 3, workers = workers())
```

Please consult
[The ultimate guide to distributed computing in Julia](https://github.com/Arpeggeo/julia-distributed-computing/tree/master).

## Point processes

```@docs
GeoStatsProcesses.PointProcess
Base.rand(::GeoStatsProcesses.PointProcess, ::Any)
```

We can use a point process to simulate random locations of events within
a given geometry of interest. When the process [`ishomogeneous`](@ref), it
is relatively easy to perform the simulation. The framework also provides
non-homogeneous point processes over different types of geometries.

```@docs
ishomogeneous
```

The following example illustrates the simulation of a homogeneous
[`PoissonProcess`](@ref) process over a sphere:

```@example simulation
# geometry of interest
sphere = Sphere((0, 0, 0), 1)

# homogeneous Poisson process
proc = PoissonProcess(5.0)

# sample two point patterns
pset = rand(proc, sphere, 2)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], sphere)
viz!(fig[1,1], pset[1], color = :black)
viz(fig[1,2], sphere)
viz!(fig[1,2], pset[2], color = :black)
fig
```

!!! note

    Please check [this page](pointprocs.md) for more examples.

#### Basic operations

Point processes can be combined using basic operations.

```@docs
Base.union(::GeoStatsProcesses.PointProcess, ::GeoStatsProcesses.PointProcess)
```

```@example simulation
# geometry of interest
box = Box((0, 0), (100, 100))

# superposition of two Binomial processes
proc₁ = BinomialProcess(500)
proc₂ = BinomialProcess(500)
proc  = proc₁ ∪ proc₂ # 1000 points

pset = rand(proc, box, 2)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], box)
viz!(fig[1,1], pset[1], color = :black)
viz(fig[1,2], box)
viz!(fig[1,2], pset[2], color = :black)
fig
```

```@docs
thin
RandomThinning
```

```@example simulation
# geometry of interest
box = Box((0, 0), (100, 100))

# reduce intensity of Poisson process by half
proc₁ = PoissonProcess(0.5)
proc₂ = thin(proc₁, RandomThinning(0.5))

# sample point patterns
pset₁ = rand(proc₁, box)
pset₂ = rand(proc₂, box)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], box)
viz!(fig[1,1], pset₁, color = :black)
viz(fig[1,2], box)
viz!(fig[1,2], pset₂, color = :black)
fig
```

```@example simulation
# geometry of interest
box = Box((0, 0), (100, 100))

# Binomial process
proc = BinomialProcess(2000)

# sample point pattern
pset₁ = rand(proc, box)

# thin point pattern with probability 0.5
pset₂ = thin(pset₁, RandomThinning(0.5))

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], box)
viz!(fig[1,1], pset₁, color = :black)
viz(fig[1,2], box)
viz!(fig[1,2], pset₂, color = :black)
fig
```
