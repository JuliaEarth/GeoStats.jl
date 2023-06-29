# Problems

```@example problems
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats, GeoStatsViz # hide
import WGLMakie as Mke # hide
```

The project provides solutions to three types of geostatistical problems.
These problems can be defined unambiguously and independently of solvers,
which is quite convenient for fair comparison of alternative workflows.

## Estimation

```@docs
EstimationProblem
```

### Example

Define a 2D estimation problem:

```@example problems
# list of properties with coordinates
props = (Z=[1.,0.,1.],)
coord = [(25.,25.), (50.,75.), (75.,50.)]

# estimation problem
𝒟 = georef(props, coord)
𝒢 = CartesianGrid(100, 100)
𝒫 = EstimationProblem(𝒟, 𝒢, :Z)
```

Solve the problem with [`Kriging`](@ref) solver:

```@example problems
# ordinary Kriging
𝒮 = Kriging(:Z => (variogram=GaussianVariogram(range=35.),))

# perform estimation
Ω = solve(𝒫, 𝒮)

# plot estimate and conditional variance
fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], Ω.geometry, color = Ω.Z)
viz(fig[1,2], Ω.geometry, color = Ω.Z_variance)
fig
```

## Simulation

```@docs
SimulationProblem
```

### Example

Define a 2D unconditional simulation problem:

```@example problems
# unconditional simulation problem
𝒢 = CartesianGrid(100, 100)
𝒫 = SimulationProblem(𝒢, :Z => Float64, 3)
```

Solve the problem with [`FFTGS`](@ref) solver:

```@example problems
# FFT-based Gaussian simulation
𝒮 = FFTGS(:Z => (variogram=GaussianVariogram(range=25.),))

# ensemble of realizations
Ω = solve(𝒫, 𝒮)

# plot realizations
fig = Mke.Figure(resolution = (800, 250))
viz(fig[1,1], Ω[1].geometry, color = Ω[1].Z)
viz(fig[1,2], Ω[2].geometry, color = Ω[2].Z)
viz(fig[1,3], Ω[3].geometry, color = Ω[3].Z)
fig
```

Alternatively, define a 2D conditional simulation problem:

```@example problems
# sample first realization
𝒟 = sample(Ω[1], 10, replace=false)

# conditional simulation problem
𝒫 = SimulationProblem(𝒟, 𝒢, :Z, 3)
```

And solve it as before:

```@example problems
# ensemble of realizations
Ω = solve(𝒫, 𝒮)

# plot realizations
fig = Mke.Figure(resolution = (800, 250))
viz(fig[1,1], Ω[1].geometry, color = Ω[1].Z)
viz(fig[1,2], Ω[2].geometry, color = Ω[2].Z)
viz(fig[1,3], Ω[3].geometry, color = Ω[3].Z)
fig
```

Solvers for simulation problems can generate realizations in parallel using multiple processes.
Doing so requires using the `Distributed` package, like in the following example.

```julia
using Distributed

# request additional processes
addprocs(3)

# load code on every single process
@everywhere using GeoStats

# ------------
# main script
# ------------

table = (Z=[1.,0.,1.],)
coord = [(25.,25.), (50.,75.), (75.,50.)]

𝒟 = georef(table, coord)
𝒢 = CartesianGrid(100, 100)

𝒫 = SimulationProblem(𝒟, 𝒢, :Z, 3)
𝒮 = LUGS(:Z => (variogram=GaussianVariogram(range=35),))

# solve on all available processes
Ω = solve(𝒫, 𝒮, procs=procs())
```

For more information on distributed computing in Julia, see
[The ultimate guide to distributed computing in Julia](https://github.com/Arpeggeo/julia-distributed-computing/tree/master).

## Learning

```@docs
LearningProblem
```

### Example

Please consult the [Quickstart](quickstart.md) for an example or
watch our JuliaCon2021 talk:

```@raw html
<p align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/75A6zyn5pIE" title="Geostatistical Learning" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</p>
```
