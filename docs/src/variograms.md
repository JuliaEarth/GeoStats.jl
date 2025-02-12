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

fig = funplot(γₕ)
funplot!(fig, γᵥ, color = :maroon, histcolor = :maroon)
```

or planar variograms over a specific plane:

```@example variograms
γᵥ = PlanarVariogram((1.,0.), img, :Z, maxlag = 50.)
γₕ = PlanarVariogram((0.,1.), img, :Z, maxlag = 50.)

fig = funplot(γₕ)
funplot!(fig, γᵥ, color = :maroon, histcolor = :maroon)
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

We provide various theoretical variogram models from the literature, which can
be combined with ellipsoid distances to model geometric anisotropy and combined
with scalars or matrix coefficients to express multivariate relations.

### Models

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

#### Gaussian

```math
\gamma(h) = (s - n) \left[1 - \exp\left(-3\left(\frac{h}{r}\right)^2\right)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
GaussianVariogram
```

```@example variograms
funplot(GaussianVariogram())
```

#### Spherical

```math
\gamma(h) = (s - n) \left[\left(\frac{3}{2}\left(\frac{h}{r}\right) + \frac{1}{2}\left(\frac{h}{r}\right)^3\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
SphericalVariogram
```

```@example variograms
funplot(SphericalVariogram())
```

#### Exponential

```math
\gamma(h) = (s - n) \left[1 - \exp\left(-3\left(\frac{h}{r}\right)\right)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
ExponentialVariogram
```

```@example variograms
funplot(ExponentialVariogram())
```

#### Matern

```math
\gamma(h) = (s - n) \left[1 - \frac{2^{1-\nu}}{\Gamma(\nu)} \left(\sqrt{2\nu}\ 3\left(\frac{h}{r}\right)\right)^\nu K_\nu\left(\sqrt{2\nu}\ 3\left(\frac{h}{r}\right)\right)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
MaternVariogram
```

```@example variograms
funplot(MaternVariogram())
```

#### Cubic

```math
\gamma(h) = (s - n) \left[\left(7\left(\frac{h}{r}\right)^2 - \frac{35}{4}\left(\frac{h}{r}\right)^3 + \frac{7}{2}\left(\frac{h}{r}\right)^5 - \frac{3}{4}\left(\frac{h}{r}\right)^7\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
CubicVariogram
```

```@example variograms
funplot(CubicVariogram())
```

#### PentaSpherical

```math
\gamma(h) = (s - n) \left[\left(\frac{15}{8}\left(\frac{h}{r}\right) - \frac{5}{4}\left(\frac{h}{r}\right)^3 + \frac{3}{8}\left(\frac{h}{r}\right)^5\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
PentaSphericalVariogram
```

```@example variograms
funplot(PentaSphericalVariogram())
```

#### Sine hole

```math
\gamma(h) = (s - n) \left[1 - \frac{\sin(\pi h / r)}{\pi h / r}\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
SineHoleVariogram
```

```@example variograms
funplot(SineHoleVariogram())
```

#### Circular

```math
\gamma(h) = (s - n) \left[\left(1 - \frac{2}{\pi} \cos^{-1}\left(\frac{h}{r}\right) + \frac{2h}{\pi r} \sqrt{1 - \frac{h^2}{r^2}} \right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
CircularVariogram
```

```@example variograms
funplot(CircularVariogram())
```

#### Power

```math
\gamma(h) = sh^a + n \cdot \1_{(0,\infty)}(h)
```

```@docs
PowerVariogram
```

```@example variograms
funplot(PowerVariogram())
```

#### Nugget

```math
\gamma(h) = n \cdot \1_{(0,\infty)}(h)
```

```@docs
NuggetEffect
```

```@example variograms
funplot(NuggetEffect())
```

### Anisotropic models

Anisotropic models can be constructed from a list of `ranges` and `rotation`
matrix from [Rotations.jl](https://github.com/JuliaGeometry/Rotations.jl):

```@example variograms
GaussianVariogram(ranges = (3.0, 2.0, 1.0), rotation = RotZXZ(0.0, 0.0, 0.0))
```

Rotation angles from commercial geostatistical software are also provided:

```@docs
MinesightAngles
DatamineAngles
VulcanAngles
GslibAngles
```

The effect of anisotropy is illustrated below for different rotation angles:

```@example variograms
using Random # hide
Random.seed!(2000) # hide

points = rand(Point, 50, crs=Cartesian2D) |> Scale(100)
geotable = georef((Z=rand(50),), points)

viz(geotable.geometry, color = geotable.Z)
```

```@example variograms
θs = range(0.0, step = π/4, stop = 2π - π/4)

# initialize figure
fig = Mke.Figure(size = (800, 1600))

# helper function to position subfigures
pos = i -> CartesianIndices((4, 2))[i].I

# domain of interpolation
grid = CartesianGrid(100, 100)

# anisotropic variogram with different rotation angles
for (i, θ) in enumerate(θs)
  # anisotropic variogram model
  γ = GaussianVariogram(ranges = (20.0, 5.0), rotation = Angle2d(θ))

  # perform interpolation
  interp = geotable |> Interpolate(grid, model=Kriging(γ))

  # visualize solution at subplot i
  viz(fig[pos(i)...],
    interp.geometry, color = interp.Z,
    axis = (title = "θ = $(rad2deg(θ))ᵒ",)
  )
end

fig
```

### Composite models

A composite variogram model
``\gamma(h) = c_1\cdot\gamma_1(h) + c_2\cdot\gamma_2(h) + \cdots + c_n\cdot\gamma_n(h)``
can be constructed from multiple variogram models, including matrix coefficients. The
individual structures can be recovered in canonical form with the [`structures`](@ref)
function:

```@docs
structures
```

```@example variograms
γ₁ = GaussianVariogram(nugget=1, sill=2)
γ₂ = ExponentialVariogram(nugget=2, sill=3)

# composite model with matrix coefficients
γ = [1.0 0.0; 0.0 1.0] * γ₁ + [2.0 0.5; 0.5 3.0] * γ₂

# structures in canonical form
cₒ, c, g = structures(γ)

cₒ # matrix nugget
```

```@example variograms
c # matrix coefficients
```

```@example variograms
g # normalized structures
```

## Fitting models

Fitting theoretical variograms to empirical observations is an important
modeling step to ensure valid mathematical models of geospatial continuity.
Given an empirical variogram, the following function can be used to fit models:

```@docs
GeoStatsFunctions.fit
```

### Example

```@example variograms
# sinusoidal data
𝒟 = georef((Z=[sin(i/2) + sin(j/2) for i in 1:50, j in 1:50],))

# empirical variogram
g = EmpiricalVariogram(𝒟, :Z, maxlag = 25u"m")

funplot(g)
```

We can fit specific models to the empirical variogram:

```@example variograms
γ = GeoStatsFunctions.fit(SineHoleVariogram, g)

fig = funplot(g)
funplot!(fig, γ, maxlag = 25u"m")
```

or let the framework find the model with minimum error:

```@example variograms
γ = GeoStatsFunctions.fit(Variogram, g)

fig = funplot(g)
funplot!(fig, γ, maxlag = 25u"m")
```

which should be a [`SineHoleVariogram`](@ref) given that the synthetic data
of this example is sinusoidal.

Optionally, we can specify a weighting function to give different weights to the lags:

```@example variograms
γ = GeoStatsFunctions.fit(SineHoleVariogram, g, h -> 1 / h^2)

fig = funplot(g)
funplot!(fig, γ, maxlag = 25u"m")
```

### Methods

#### Weighted least squares

```@docs
WeightedLeastSquares
```
