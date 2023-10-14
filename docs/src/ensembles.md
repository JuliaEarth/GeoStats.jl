# Ensembles

```@example ensemble
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats # hide
import WGLMakie as Mke # hide
```

```@docs
Ensemble
```

Consider the following solution to a conditional simulation problem:

```@example ensemble
# list of properties with coordinates
props = (Z=[1.,0.,1.],)
coord = [(25.,25.), (50.,75.), (75.,50.)]

# request 100 realizations
𝒟 = georef(props, coord)
𝒢 = CartesianGrid(100, 100)
𝒫 = SimulationProblem(𝒟, 𝒢, :Z, 100)

# FFT-based Gaussian simulation
𝒮 = FFTGS(:Z => (variogram=GaussianVariogram(range=30.),))

# generate ensemble
Ω = solve(𝒫, 𝒮)
```

We can visualize a few realizations in the ensemble:

```@example ensemble
fig = Mke.Figure(resolution = (800, 250))
viz(fig[1,1], Ω[1].geometry, color = Ω[1].Z)
viz(fig[1,2], Ω[2].geometry, color = Ω[2].Z)
viz(fig[1,3], Ω[3].geometry, color = Ω[3].Z)
fig
```

or alternatively, the mean and variance:

```@example ensemble
m, v = mean(Ω), var(Ω)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], m.geometry, color = m.Z)
viz(fig[1,2], v.geometry, color = v.Z)
fig
```

or the 25th and 75th percentiles:

```@example ensemble
q25 = quantile(Ω, 0.25)
q75 = quantile(Ω, 0.75)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], q25.geometry, color = q25.Z)
viz(fig[1,2], q75.geometry, color = q75.Z)
fig
```

All these objects are examples of geospatial data as described in
the [Data](data.md) section.