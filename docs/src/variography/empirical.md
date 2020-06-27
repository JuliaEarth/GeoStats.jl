# Empirical variograms

An empirical variogram has the form:

```math
\hat{\gamma}(h) = \frac{1}{2|N(h)|} \sum_{(i,j) \in N(h)} (z_i - z_j)^2
```

where ``N(h) = \left\{(i,j) \mid ||\x_i - \x_j|| = h\right\}`` is the set
of pairs of locations at a distance ``h`` and ``|N(h)|`` is the cardinality
of the set. Empirical variograms can be estimated using general distance
functions. These can be used in order to for example:

- Model anisotropy (e.g. ellipsoid distance)
- Perform geostatistical simulation on spherical coordinate systems (e.g. haversine distance)

Please see [Distances.jl](https://github.com/JuliaStats/Distances.jl)
for a complete list of options.

Additionally, given two empirical variograms ``\hat{\gamma}_\alpha`` and ``\hat{\gamma}_\beta``,
they can be merged as described in Hoffimann & Zadrozny 2019:

```math
\hat{\gamma}_{\alpha+\beta}(h) =
\frac{|N_\alpha(h)| \cdot \hat{\gamma}_\alpha(h) + |N_\beta(h)| \cdot \hat{\gamma}_\beta(h)}{|N_\alpha(h)| + |N_\beta(h)|}
```

```@docs
merge(::EmpiricalVariogram, ::EmpiricalVariogram)
```

## Variograms

Consider the following image for illustration purposes:

```@example empirical
using GeoStats #hide
using GeoStatsImages
using Plots #hide

𝒟 = geostatsimage("Gaussian30x10")

plot(𝒟)
```

```@docs
EmpiricalVariogram
```

```@example empirical
γ = EmpiricalVariogram(𝒟, :Z, maxlag=50.)

plot(γ)
```

```@docs
DirectionalVariogram
```

```@example empirical
γₕ = DirectionalVariogram((1.,0.), 𝒟, :Z, maxlag=50.)
γᵥ = DirectionalVariogram((0.,1.), 𝒟, :Z, maxlag=50.)

plot(γₕ, label="horizontal")
plot!(γᵥ, label="vertical")
```

```@docs
PlanarVariogram
```

```@example empirical
γᵥ = PlanarVariogram((1.,0.), 𝒟, :Z, maxlag=50.)
γₕ = PlanarVariogram((0.,1.), 𝒟, :Z, maxlag=50.)

plot(γₕ, label="horizontal")
plot!(γᵥ, label="vertical")
```

## Varioplanes

```@docs
EmpiricalVarioplane
```

```@example empirical
γ = EmpiricalVarioplane(𝒟, :Z, maxlag=50.)

plot(γ)
```
