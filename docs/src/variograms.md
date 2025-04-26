# Variograms

```@example variograms
using GeoStats # hide
import CairoMakie as Mke # hide
```

## Empirical variograms

Variograms are widely used in geostatistics due to their intimate connection
with (co)variance and visual interpretability. The following video explains
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

where ``N(h) = \left\{(i,j) \mid ||\p_i - \p_j|| = h\right\}`` is the set
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

### (Omini)directional variograms

```@docs
EmpiricalVariogram
DirectionalVariogram
PlanarVariogram
```

Consider the following example image:

```@example variograms
using GeoStatsImages

img = geostatsimage("Gaussian30x10")

img |> viewer
```

We can estimate ominidirectional variograms, which
consider pairs of points along all directions:

```@example variograms
γ = EmpiricalVariogram(img, :Z, maxlag = 50.)

funplot(γ)
```

directional variograms along a specific direction:

```@example variograms
γₕ = DirectionalVariogram((1.,0.), img, :Z, maxlag = 50.)
γᵥ = DirectionalVariogram((0.,1.), img, :Z, maxlag = 50.)

fig = funplot(γₕ, color = :maroon, histcolor = :maroon)
funplot!(fig, γᵥ)
```

or planar variograms over a specific plane:

```@example variograms
γᵥ = PlanarVariogram((1.,0.), img, :Z, maxlag = 50.)
γₕ = PlanarVariogram((0.,1.), img, :Z, maxlag = 50.)

fig = funplot(γₕ, color = :maroon, histcolor = :maroon)
funplot!(fig, γᵥ)
```

!!! note

    The directional and planar variograms coincide in this example
    because planes are equal to lines in 2-dimensional space. These
    concepts are most useful in 3-dimensional space where we may be
    interested in comparing the horizontal planar range to the
    vertical directional range.

### Empirical surfaces

```@docs
EmpiricalVariogramSurface
```

```@example variograms
γ = EmpiricalVariogramSurface(img, :Z, maxlag = 50.)

surfplot(γ)
```

## Theoretical variograms

We provide various theoretical variograms from the literature, which can
be combined with ellipsoid distances to model geometric anisotropy and
with scalars or matrix coefficients to express multivariate relations.
Please check the [Functions](functions.md) section for more details.

In an intrinsic isotropic model, the variogram is only a function of the
distance between any two given points ``\p_1,\p_2 \in \R^m``:

```math
\gamma(\p_1,\p_2) = \gamma(||\p_1 - \p_2||) = \gamma(h)
```

Under the additional assumption of 2nd-order stationarity, the well-known
covariance is directly related via ``\gamma(h) = \cov(0) - \cov(h)``.
This package implements a few commonly used as well as other more exotic
variogram models. Most of these models share a set of default parameters
(e.g. `sill=1.0`, `range=1.0`), which can be set with keyword arguments.

### Gaussian

```math
\gamma(h) = (s - n) \left[1 - \exp\left(-3\left(\frac{h}{r}\right)^2\right)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
GaussianVariogram
```

```@example variograms
funplot(GaussianVariogram())
```

### Spherical

```math
\gamma(h) = (s - n) \left[\left(\frac{3}{2}\left(\frac{h}{r}\right) + \frac{1}{2}\left(\frac{h}{r}\right)^3\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
SphericalVariogram
```

```@example variograms
funplot(SphericalVariogram())
```

### Exponential

```math
\gamma(h) = (s - n) \left[1 - \exp\left(-3\left(\frac{h}{r}\right)\right)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
ExponentialVariogram
```

```@example variograms
funplot(ExponentialVariogram())
```

### Matern

```math
\gamma(h) = (s - n) \left[1 - \frac{2^{1-\nu}}{\Gamma(\nu)} \left(\sqrt{2\nu}\ 3\left(\frac{h}{r}\right)\right)^\nu K_\nu\left(\sqrt{2\nu}\ 3\left(\frac{h}{r}\right)\right)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
MaternVariogram
```

```@example variograms
funplot(MaternVariogram())
```

### Cubic

```math
\gamma(h) = (s - n) \left[\left(7\left(\frac{h}{r}\right)^2 - \frac{35}{4}\left(\frac{h}{r}\right)^3 + \frac{7}{2}\left(\frac{h}{r}\right)^5 - \frac{3}{4}\left(\frac{h}{r}\right)^7\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
CubicVariogram
```

```@example variograms
funplot(CubicVariogram())
```

### PentaSpherical

```math
\gamma(h) = (s - n) \left[\left(\frac{15}{8}\left(\frac{h}{r}\right) - \frac{5}{4}\left(\frac{h}{r}\right)^3 + \frac{3}{8}\left(\frac{h}{r}\right)^5\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
PentaSphericalVariogram
```

```@example variograms
funplot(PentaSphericalVariogram())
```

### Sine hole

```math
\gamma(h) = (s - n) \left[1 - \frac{\sin(\pi h / r)}{\pi h / r}\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
SineHoleVariogram
```

```@example variograms
funplot(SineHoleVariogram())
```

### Circular

```math
\gamma(h) = (s - n) \left[\left(1 - \frac{2}{\pi} \cos^{-1}\left(\frac{h}{r}\right) + \frac{2h}{\pi r} \sqrt{1 - \frac{h^2}{r^2}} \right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
CircularVariogram
```

```@example variograms
funplot(CircularVariogram())
```

### Power

```math
\gamma(h) = s\left(\frac{h}{l}\right)^a + n \cdot \1_{(0,\infty)}(h)
```

```@docs
PowerVariogram
```

```@example variograms
funplot(PowerVariogram())
```

### Nugget

```math
\gamma(h) = n \cdot \1_{(0,\infty)}(h)
```

```@docs
NuggetEffect
```

```@example variograms
funplot(NuggetEffect())
```
