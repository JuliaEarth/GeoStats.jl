# Problems

The project provides solutions to three types of geostatistical problems.
These problems can be defined unambiguously and independently of solvers,
which is quite convenient for fair comparison of alternative workflows.

## Estimation

```@docs
EstimationProblem
```

### Example

Define a 2D estimation problem:

```@example estimation
using GeoStats # hide
using Plots # hide
using GeoStatsPlots # hide
gr(size=(900,400),clabels=true) # hide

# list of properties with coordinates
props = (Z=[1.,0.,1.],)
coord = [(25.,25.), (50.,75.), (75.,50.)]

# estimation problem
𝒟 = georef(props, coord)
𝒢 = CartesianGrid(100, 100)
𝒫 = EstimationProblem(𝒟, 𝒢, :Z)
```

Solve the problem with a few built-in solvers:

```@example estimation
# few built-in solvers
S1 = IDW(:Z => (distance=Euclidean(),))
S2 = IDW(:Z => (distance=Chebyshev(),))
S3 = Kriging(:Z => (variogram=GaussianVariogram(range=35.),))

# solve the problem
sol = [solve(𝒫, S) for S in (S1, S2, S3)]

# plot the solution
contourf(sol[1])
```

```@example estimation
contourf(sol[2])
```

```@example estimation
contourf(sol[3])
```

## Simulation

```@docs
SimulationProblem
```

### Example

Define a 2D unconditional simulation problem:

```@example simulation
using GeoStats # hide
using Plots # hide
using GeoStatsPlots # hide
gr(size=(900,300)) # hide

# unconditional simulation problem
𝒢 = CartesianGrid(100, 100)
𝒫 = SimulationProblem(𝒢, :Z => Float64, 3)
```

Solve the problem with a few built-in solvers:

```@example simulation
# few built-in solvers
S1 = LUGS(:Z => (variogram=GaussianVariogram(range=25.),))
S2 = FFTGS(:Z => (variogram=GaussianVariogram(range=25.),))

# solve the problem
sol = [solve(𝒫, S) for S in (S1, S2)]

# plot the solution
heatmap(sol[1])
```

```@example simulation
heatmap(sol[2])
```

Alternatively, define a 2D conditional simulation problem:

```@example simulation
# unconditional realization
Z1 = sol[1][1]

# sample observations
𝒟 = sample(Z1, 10, replace=false)

# conditional simulation problem
𝒫 = SimulationProblem(𝒟, 𝒢, :Z, 3)
```

And solve it as before:

```@example simulation
# solve the problem
sol = solve(𝒫, S1)

# plot the solution
heatmap(sol)
```

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
