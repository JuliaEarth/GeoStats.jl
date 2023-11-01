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

##### Basic Examples

```@example fieldprocs
using GeoArtifacts

sdomain = CartesianGrid(200, 200)
trainimg = GeoArtifacts.geostatsimage("Strebelle")
tilesize = (62, 62)
process = QuiltingProcess(trainimg, tilesize)

real = rand(process, sdomain, [:facies => Int], 2)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].facies)
viz(fig[1,2], real[2].geometry, color = real[2].facies)
fig
```

```@example fieldprocs
sdomain = CartesianGrid(200, 200)
trainimg = GeoArtifacts.geostatsimage("StoneWall")
tilesize = (13, 13)
process = QuiltingProcess(trainimg, tilesize)

real = rand(process, sdomain, [:z => Int], 2)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].z)
viz(fig[1,2], real[2].geometry, color = real[2].z)
fig
```

```@example fieldprocs
trainimg = GeoArtifacts.geostatsimage("Strebelle")
observed = trainimg |> Sample(20, replace=false)

sdomain = domain(trainimg)
tilesize = (30, 30)
process = QuiltingProcess(trainimg, tilesize)

real = rand(process, sdomain, observed, 2)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].facies)
viz(fig[1,2], real[2].geometry, color = real[2].facies)
fig
```

##### Masked grids

Voxels marked with the special symbol `NaN` are treated as inactive.
The algorithm will skip tiles that only contain inactive voxels to 
save computation and will generate realizations that are consistent
with the mask. This is particularly useful with complex 3D models that 
have large inactive portions.

```@example fieldprocs
trainimg = GeoArtifacts.geostatsimage("Strebelle")

# skip circle at the center
nx, ny = size(domain(trainimg))
r = 100; circle = []
for i in 1:nx, j in 1:ny
  if (i-nx÷2)^2 + (j-ny÷2)^2 < r^2
    push!(circle, CartesianIndex(i, j))
  end
end

sdomain = domain(trainimg)
tilesize = (30, 30)
process = QuiltingProcess(trainimg, tilesize)

real = rand(process, sdomain, [:facies => Float64], 2)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].facies)
viz(fig[1,2], real[2].geometry, color = real[2].facies)
fig
```

##### Soft data

It is possible to incorporate auxiliary variables to guide the 
selection of patterns from the training image.

```@example fieldprocs
using ImageFiltering

# image assumed as ground truth (unknown)
truthimg = GeoArtifacts.geostatsimage("WalkerLakeTruth")

# training image with similar patterns
trainimg = GeoArtifacts.geostatsimage("WalkerLake")

# forward model (blur filter)
function forward(data)
  img = asarray(data, :Z)
  krn = KernelFactors.IIRGaussian([10,10])
  fwd = imfilter(img, krn)
  georef((; fwd), domain(data))
end

# apply forward model to both images
data   = forward(truthimg)
dataTI = forward(trainimg)

sdomain = domain(truthimg)
tilesize = (27, 27)
soft = (data, dataTI)
process = QuiltingProcess(trainimg, tilesize; soft)

real = rand(process, sdomain, [:z => Float64], 2)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].z)
viz(fig[1,2], real[2].geometry, color = real[2].z)
fig
```

#### TuringPatterns.jl

```@docs
TuringProcess
```

##### Example

```@example fieldprocs
sdomain = CartesianGrid(200, 200)
real = rand(TuringProcess(), sdomain, [:z => Float64], 2)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].z)
viz(fig[1,2], real[2].geometry, color = real[2].z)
fig
```

#### StratiGraphics.jl

```@docs
StrataProcess
```

##### Example

```@example fieldprocs
proc = SmoothingProcess()
ΔT = ExponentialDuration(1.0)
env = Environment([proc, proc], [0.5 0.5; 0.5 0.5], ΔT)
sdomain = CartesianGrid(50, 50, 20)
real = rand(StrataProcess(env), sdomain, [:z => Float64], 3)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].z)
viz(fig[1,2], real[2].geometry, color = real[2].z)
fig
```

## Methods

```@docs
LUMethod
FFTMethod
SEQMethod
```
