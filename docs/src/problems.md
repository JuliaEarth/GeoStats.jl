# Problems

```@example problems
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats # hide
import WGLMakie as Mke # hide
```

The project provides solutions to different types of geostatistical problems.
These problems can be defined unambiguously and independently of solvers,
which is quite convenient for fair comparison of alternative workflows.

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

Solve the problem with [`LUGS`](@ref) solver:

```@example problems
# LU-based Gaussian simulation
𝒮 = LUGS(:Z => (variogram=GaussianVariogram(range=25.),))

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
𝒟 = sample(Ω[1], UniformSampling(100))

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

## Learning

```@docs
LearningProblem
```

### Example

Please consult the [Quickstart](quickstart.md) for an example or
watch our JuliaCon2021 talk:

```@raw html
<p align="center">
<iframe style="width:560px;height:315px" src="https://www.youtube.com/embed/75A6zyn5pIE" title="Geostatistical Learning" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</p>
```

Besides the unsupervised [Clustering](clustering.md) algorithms, the framework defines
algorithms for two supervised learning tasks:

```@docs
RegressionTask
ClassificationTask
```

These tasks can be learned and performed with geospatial data using any learning model
from the [MLJ.jl](https://github.com/alan-turing-institute/MLJ.jl) project:

```@docs
learn(::LearningTask, ::AbstractGeoTable, ::Any)
perform(::LearningTask, ::AbstractGeoTable, ::Any)
```