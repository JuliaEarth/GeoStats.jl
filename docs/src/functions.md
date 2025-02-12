# Overview

```@example functions
using GeoStats # hide
import CairoMakie as Mke # hide
```

Geostatistical functions describe geospatial association of samples
based on their locations. These functions have different properties,
which are relevant for specific applications, and are documented in
the [Variograms](variograms.md), [Covariances](covariances.md) and
[Transiograms](transiograms.md) sections.

Below we list the general properties of all geostatistical functions
as well as utilities to properly plot these functions.

## Properties

The following properties can be checked about a geostatistical function:

```@docs
isstationary(::GeoStatsFunction)
isisotropic(::GeoStatsFunction)
issymmetric(::GeoStatsFunction)
isbanded(::GeoStatsFunction)
metricball(::GeoStatsFunction)
range(::GeoStatsFunction)
nvariates(::GeoStatsFunction)
```

## Plotting

The function [`funplot`](@ref)/[`funplot!`](@ref) can be used to plot
any geostatistical function, including composite anisotropic models.

```@docs
funplot
funplot!
```

Consider the following example with an anisotropic Gaussian variogram:

```@example functions
γ = GaussianVariogram(ranges=(3, 2, 1))
```

```@example functions
funplot(γ)
```

The function [`surfplot`](@ref)/[`surfplot!`](@ref) can be used to plot
surfaces of association given a normal direction:

```@docs
surfplot
surfplot!
```

```@example functions
surfplot(γ)
```
