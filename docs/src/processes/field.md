# Field processes

```@example fieldprocs
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats # hide
import WGLMakie as Mke # hide
```

## Overview

```@docs
Base.rand(::GeoStatsProcesses.FieldProcess, ::Domain, ::Any, ::Any)
```

```@example fieldprocs
# domain of interest
grid = CartesianGrid(100, 100)

# Gaussian process
proc = GaussianProcess(variogram=GaussianVariogram(range=30.0))

# request two realizations of variable z
real = rand(proc, grid, [:z => Float64], 2)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].z)
viz(fig[1,2], real[2].geometry, color = real[2].z)
fig
```

### Distributed computing

All field processes can generate realizations in parallel
using multiple Julia processes. Doing so requires using the
[Distributed](https://docs.julialang.org/en/v1/stdlib/Distributed/)
standard library, like in the following example:

```julia
using Distributed

# request additional processes
addprocs(3)

# load code on every single process
@everywhere using GeoStats

# ------------
# main script
# ------------

# domain of interest
grid = CartesianGrid(100, 100)

# Gaussian process
proc = GaussianProcess(GaussianVariogram(range=30.0))

# generate three realizations with three processes
real = rand(proc, grid, [:z => Float64], 3, pool = workers())
```

Please consult
[The ultimate guide to distributed computing in Julia](https://github.com/Arpeggeo/julia-distributed-computing/tree/master).

## Types

### Builtin

The following processes are shipped with the framework.

```@docs
GaussianProcess
```

```@docs
LindgrenProcess
```

### External

The following processes are available in external packages.

#### ImageQuilting.jl

```@docs
QuiltingProcess
```

#### TuringPatterns.jl

```@docs
TuringProcess
```

#### StratiGraphics.jl

```@docs
StrataProcess
```

## Methods

```@docs
LUMethod
FFTMethod
SEQMethod
```