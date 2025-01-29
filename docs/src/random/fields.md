# Fields

```@example fieldprocs
using GeoStats # hide
import CairoMakie as Mke # hide
```

## Builtin

The following processes are available upon loading GeoStats.jl.

```@docs
GaussianProcess
LindgrenProcess
```

The [`GaussianProcess`](@ref) can be simulated with various
methods from the literature:

```@docs
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

```@example fieldprocs
# domain of interest
mesh = simplexify(Sphere((0, 0, 0), 1))

# Lindgren process
proc = LindgrenProcess()

# unconditional simulation
real = rand(proc, mesh, [:Z => Float64], 2)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].Z)
viz(fig[1,2], real[2].geometry, color = real[2].Z)
fig
```

## External

The following processes are available upon loading external packages.

### ImageQuilting.jl

```@docs
QuiltingProcess
```

```@example fieldprocs
using ImageQuilting
using GeoStatsImages

# domain of interest
grid = CartesianGrid(200, 200)

# quilting process
img  = geostatsimage("Strebelle")
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
img  = geostatsimage("StoneWall")
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
img  = geostatsimage("Strebelle")
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
truth = geostatsimage("WalkerLakeTruth")

# training image with similar patterns
img = geostatsimage("WalkerLake")

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
