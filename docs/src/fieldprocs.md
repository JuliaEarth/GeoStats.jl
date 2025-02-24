# Field processes

```@example fieldprocs
using GeoStats # hide
import CairoMakie as Mke # hide
```

## Builtin

The following field processes are available upon loading GeoStats.jl.

```@docs
GaussianProcess
```

```@example fieldprocs
# domain of interest
grid = CartesianGrid(100, 100)

# Gaussian process
proc = GaussianProcess(GaussianVariogram(range=30.0))

# unconditional simulation
real = rand(proc, grid, 2)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].field)
viz(fig[1,2], real[2].geometry, color = real[2].field)
fig
```

The [`GaussianProcess`](@ref) can be simulated with different methods.
Heuristics are used to select the most appropriate method for the data
and domain at hand.

```@docs
LUSIM
FFTSIM
SEQSIM
```

```@docs
IndicatorProcess
```

```@example fieldprocs
# domain of interest
grid = CartesianGrid(100, 100)

# multivariate function modeling categorical values
func = SphericalTransiogram(ranges=(50.0, 10.), proportions=(0.5, 0.3, 0.2))

# indicator process
proc = IndicatorProcess(func)

# unconditional simulation
real = rand(proc, grid, 2)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].field)
viz(fig[1,2], real[2].geometry, color = real[2].field)
fig
```

```@example fieldprocs
# data with categorical column
table = (; facies=["shale", "sand", "clay"])
coord = [(25.0, 25.0), (50.0, 75.0), (75.0, 25.0)]
data = georef(table, coord)

# conditional simulation
real = rand(proc, grid, data=data)

# visualize realization
real |> viewer
```

```@docs
LindgrenProcess
```

```@example fieldprocs
# domain of interest
mesh = simplexify(Sphere((0, 0, 0), 1))

# Lindgren process
proc = LindgrenProcess()

# unconditional simulation
real = rand(proc, mesh, 2)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].field)
viz(fig[1,2], real[2].geometry, color = real[2].field)
fig
```

## External

The following field processes are available upon loading external packages.

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
real = rand(proc, grid, 2)

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
real = rand(proc, grid, 2)

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
real = rand(proc, grid, 2, data=data)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].facies)
viz(fig[1,2], real[2].geometry, color = real[2].facies)
fig
```

The `QuiltingProcess` can be simulated over views of grids,
as in the example below where we simulate patterns inside
a ball:


```@example fieldprocs
# domain of training image
grid = domain(img)

# view pixels inside ball
ball = Ball((50.0, 50.0), 25.0)
vgrid = view(grid, ball)

# quilting process
proc = QuiltingProcess(img, (62, 62))

# unconditional simulation
real = rand(proc, vgrid, 2)

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

real = rand(proc, domain(truth), 2)

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
real = rand(TuringProcess(), grid, 2)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].field)
viz(fig[1,2], real[2].geometry, color = real[2].field)
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
real = rand(StrataProcess(ℰ), grid, 2)

fig = Mke.Figure(size = (800, 400))
viz(fig[1,1], real[1].geometry, color = real[1].field)
viz(fig[1,2], real[2].geometry, color = real[2].field)
fig
```
