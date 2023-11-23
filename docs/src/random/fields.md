# Fields

```@example fieldprocs
using GeoStats # hide
import CairoMakie as Mke # hide
```

```@docs
Base.rand(::GeoStatsProcesses.FieldProcess, ::Domain, ::Any, ::Any)
```

Realizations are stored in an [`Ensemble`](@ref) as illustrated in
the following example:

```@docs
Ensemble
```

```@example fieldprocs
# domain of interest
grid = CartesianGrid(100, 100)

# Gaussian process
proc = GaussianProcess(GaussianVariogram(range=30.0))

# unconditional simulation
real = rand(proc, grid, [:Z => Float64], 100)
```

We can visualize the first two realizations:

```@example fieldprocs
fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].Z)
viz(fig[1,2], real[2].geometry, color = real[2].Z)
fig
```

the mean and variance:

```@example fieldprocs
m, v = mean(real), var(real)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], m.geometry, color = m.Z)
viz(fig[1,2], v.geometry, color = v.Z)
fig
```

or the 25th and 75th percentiles:

```@example fieldprocs
q25 = quantile(real, 0.25)
q75 = quantile(real, 0.75)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], q25.geometry, color = q25.Z)
viz(fig[1,2], q75.geometry, color = q75.Z)
fig
```

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
real = rand(proc, grid, [:Z => Float64], 3, pool = workers())
```

Please consult
[The ultimate guide to distributed computing in Julia](https://github.com/Arpeggeo/julia-distributed-computing/tree/master).

## Builtin

The following processes are shipped with the framework.

```@docs
GaussianProcess
LUMethod
FFTMethod
SEQMethod
```

```@example fieldprocs
# domain of interest
grid = CartesianGrid(100, 100)

# Gaussian process
proc = GaussianProcess(GaussianVariogram(range=30.0))

# unconditional simulation
real = rand(proc, grid, [:Z => Float64], 2)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].Z)
viz(fig[1,2], real[2].geometry, color = real[2].Z)
fig
```

```@docs
LindgrenProcess
```

## External

The following processes are available in external packages.

### ImageQuilting.jl

```@docs
QuiltingProcess
```

```@example fieldprocs
using ImageQuilting
using GeoArtifacts

# domain of interest
grid = CartesianGrid(200, 200)

# quilting process
img  = GeoArtifacts.image("Strebelle")
proc = QuiltingProcess(img, (62, 62))

# unconditional simulation
real = rand(proc, grid, [:facies => Int], 2)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].facies)
viz(fig[1,2], real[2].geometry, color = real[2].facies)
fig
```

```@example fieldprocs
# domain of interest
grid = CartesianGrid(200, 200)

# quilting process
img  = GeoArtifacts.image("StoneWall")
proc = QuiltingProcess(img, (13, 13))

# unconditional simulation
real = rand(proc, grid, [:Z => Int], 2)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].Z)
viz(fig[1,2], real[2].geometry, color = real[2].Z)
fig
```

```@example fieldprocs
# domain of interest
grid = domain(img)

# pre-existing observations
img  = GeoArtifacts.image("Strebelle")
data = img |> Sample(20, replace=false)

# quilting process
proc = QuiltingProcess(img, (30, 30))

# conditional simulation
real = rand(proc, grid, data, 2)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].facies)
viz(fig[1,2], real[2].geometry, color = real[2].facies)
fig
```

Voxels marked with the special symbol `NaN` are treated as inactive.
The algorithm will skip tiles that only contain inactive voxels to 
save computation and will generate realizations that are consistent
with the mask. This is particularly useful with complex 3D models that 
have large inactive portions.

```@example fieldprocs
# domain of interest
grid = domain(img)

# skip circle at the center
nx, ny = size(grid)
r = 100; circle = []
for i in 1:nx, j in 1:ny
  if (i-nx÷2)^2 + (j-ny÷2)^2 < r^2
    push!(circle, CartesianIndex(i, j))
  end
end

# quilting process
proc = QuiltingProcess(img, (62, 62), inactive = circle)

# unconditional simulation
real = rand(proc, grid, [:facies => Float64], 2)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].facies)
viz(fig[1,2], real[2].geometry, color = real[2].facies)
fig
```

It is possible to incorporate auxiliary variables to guide the 
selection of patterns from the training image.

```@example fieldprocs
using ImageFiltering

# image assumed as ground truth (unknown)
truth = GeoArtifacts.image("WalkerLakeTruth")

# training image with similar patterns
img = GeoArtifacts.image("WalkerLake")

# forward model (blur filter)
function forward(data)
  img = asarray(data, :Z)
  krn = KernelFactors.IIRGaussian([10,10])
  fwd = imfilter(img, krn)
  georef((; fwd=vec(fwd)), domain(data))
end

# apply forward model to both images
data   = forward(truth)
dataTI = forward(img)

proc = QuiltingProcess(img, (27, 27), soft=(data, dataTI))

real = rand(proc, domain(truth), [:Z => Float64], 2)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].Z)
viz(fig[1,2], real[2].geometry, color = real[2].Z)
fig
```

### TuringPatterns.jl

```@docs
TuringProcess
```

```@example fieldprocs
using TuringPatterns

# domain of interest
grid = CartesianGrid(200, 200)

# unconditional simulation
real = rand(TuringProcess(), grid, [:z => Float64], 2)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].z)
viz(fig[1,2], real[2].geometry, color = real[2].z)
fig
```

### StratiGraphics.jl

```@docs
StrataProcess
```

```@example fieldprocs
using StratiGraphics

# domain of interest
grid = CartesianGrid(50, 50, 20)

# stratigraphic environment
p = SmoothingProcess()
T = [0.5 0.5; 0.5 0.5]
Δ = ExponentialDuration(1.0)
ℰ = Environment([p, p], T, Δ)

# strata simulation
real = rand(StrataProcess(ℰ), grid, [:z => Float64], 2)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].z)
viz(fig[1,2], real[2].geometry, color = real[2].z)
fig
```
