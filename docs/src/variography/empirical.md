# Empirical variograms

```@example empirical
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats # hide
import WGLMakie as Mke # hide
```

The Matheron's estimator of an empirical variogram is given by

```math
\widehat{\gamma_M}(h) = \frac{1}{2|N(h)|} \sum_{(i,j) \in N(h)} (z_i - z_j)^2
```

where ``N(h) = \left\{(i,j) \mid ||\x_i - \x_j|| = h\right\}`` is the set
of pairs of locations at a distance ``h`` and ``|N(h)|`` is the cardinality
of the set. Alternatively, the robust Cressie's estimator is given by

```math
\widehat{\gamma_C}(h) = \frac{1}{2}\frac{\left\{\frac{1}{|N(h)|} \sum_{(i,j) \in N(h)} |z_i - z_j|^{1/2}\right\}^4}{0.457 + \frac{0.494}{|N(h)|} + \frac{0.045}{|N(h)|^2}}
```

Both estimators are available and can be used with general distance functions
in order to for example:

- Model anisotropy (e.g. ellipsoid distance)
- Perform simulation on sphere (e.g. haversine distance)

Please see [Distances.jl](https://github.com/JuliaStats/Distances.jl)
for a complete list of distance functions.

## (Omini)directional

```@docs
EmpiricalVariogram
DirectionalVariogram
PlanarVariogram
values(::EmpiricalVariogram)
distance(::EmpiricalVariogram)
estimator(::EmpiricalVariogram)
merge(::EmpiricalVariogram{V,D,E}, ::EmpiricalVariogram{V,D,E}) where {V,D,E}
```

Consider the following example image:

```@example empirical
using GeoStatsImages

𝒟 = geostatsimage("Gaussian30x10")

viz(𝒟.geometry, color = 𝒟.Z)
```

We can compute ominidirectional variograms, which
consider pairs of points along all directions:

```@example empirical
γ = EmpiricalVariogram(𝒟, :Z, maxlag=50.)

Mke.plot(γ)
```

directional variograms along a specific direction:

```@example empirical
γₕ = DirectionalVariogram((1.,0.), 𝒟, :Z, maxlag=50.)
γᵥ = DirectionalVariogram((0.,1.), 𝒟, :Z, maxlag=50.)

Mke.plot(γₕ, label="horizontal")
Mke.plot!(γᵥ, label="vertical")
Mke.current_figure()
```

or planar variograms along a specific plane:

```@example empirical
γᵥ = PlanarVariogram((1.,0.), 𝒟, :Z, maxlag=50.)
γₕ = PlanarVariogram((0.,1.), 𝒟, :Z, maxlag=50.)

Mke.plot(γₕ, label="horizontal")
Mke.plot!(γᵥ, label="vertical")
Mke.current_figure()
```

## Varioplanes

```@docs
EmpiricalVarioplane
```

The varioplane is plotted on a polar axis
for all lags and angles:

```@example empirical
γ = EmpiricalVarioplane(𝒟, :Z, maxlag=50.)

fig = Mke.Figure()
ax = Mke.PolarAxis(fig[1,1], title = "Varioplane")
Mke.plot!(ax, γ)
fig
```
