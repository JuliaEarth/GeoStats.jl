# Empirical variograms

```@example empiricalvariogram
using GeoStats # hide
import CairoMakie as Mke # hide
```

Variograms are widely used in geostatistics due to their intimate connection
with (cross-)variance and visual interpretability. The following video explains
the concept in detail:

```@raw html
<p align="center">
<iframe style="width:560px;height:315px" src="https://www.youtube.com/embed/z8tZ6qIt9Fc" title="Variography Game" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</p>
```

The Matheron's estimator of the empirical variogram is given by

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

The high-performance estimation procedure implemented in the framework can
consider all pairs of locations regardless of direction (ominidirectional)
or a specified partition of the geospatial data (e.g. directional, planar).

Variograms can plotted with the following options:

```@docs
varioplot
```

## (Omini)directional

```@docs
EmpiricalVariogram
DirectionalVariogram
PlanarVariogram
```

Consider the following example image:

```@example empiricalvariogram
using GeoStatsImages

img = geostatsimage("Gaussian30x10")

img |> viewer
```

We can estimate ominidirectional variograms, which
consider pairs of points along all directions:

```@example empiricalvariogram
γ = EmpiricalVariogram(img, :Z, maxlag = 50.)

varioplot(γ)
```

directional variograms along a specific direction:

```@example empiricalvariogram
γₕ = DirectionalVariogram((1.,0.), img, :Z, maxlag = 50.)
γᵥ = DirectionalVariogram((0.,1.), img, :Z, maxlag = 50.)

varioplot(γₕ, color = :maroon, histcolor = :maroon)
varioplot!(γᵥ)
Mke.current_figure()
```

or planar variograms over a specific plane:

```@example empiricalvariogram
γᵥ = PlanarVariogram((1.,0.), img, :Z, maxlag = 50.)
γₕ = PlanarVariogram((0.,1.), img, :Z, maxlag = 50.)

varioplot(γₕ, color = :maroon, histcolor = :maroon)
varioplot!(γᵥ)
Mke.current_figure()
```

!!! note

    The directional and planar variograms coincide in this example
    because planes are equal to lines in 2-dimensional space. These
    concepts are most useful in 3-dimensional space where we may be
    interested in comparing the horizontal planar range to the
    vertical directional range.

## Varioplanes

Variograms estimated along all directions in a given plane of reference are
called varioplanes.

```@docs
EmpiricalVarioplane
```

The varioplane is plotted on a polar axis for all lags and angles:

```@example empiricalvariogram
γ = EmpiricalVarioplane(img, :Z, maxlag = 50.)

planeplot(γ)
```
