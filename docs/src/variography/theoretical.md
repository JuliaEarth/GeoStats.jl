# Theoretical variograms

```@example variograms
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats # hide
import WGLMakie as Mke # hide
```

We provide various theoretical variogram models from the literature, which can
can be combined with ellipsoid distances to model geometric anisotropy and nested
with scalars or matrix coefficients to express multivariate relations.

## Models

In an intrinsic isotropic model, the variogram is only a function of the
distance between any two points ``\x_1,\x_2 \in \R^m``:

```math
\gamma(\x_1,\x_2) = \gamma(||\x_1 - \x_2||) = \gamma(h)
```

Under the additional assumption of 2nd-order stationarity, the well-known
covariance is directly related via ``\gamma(h) = \cov(0) - \cov(h)``.
This package implements a few commonly used as well as other more exotic
variogram models. Most of these models share a set of default parameters
(e.g. `sill=1.0`, `range=1.0`), which can be set with keyword arguments.

Functions are provided to query properties of variogram models programmatically:

```@docs
isstationary(::Variogram)
isisotropic(::Variogram)
```

### Gaussian

```math
\gamma(h) = (s - n) \left[1 - \exp\left(-3\left(\frac{h}{r}\right)^2\right)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
GaussianVariogram
```

```@example variograms
Mke.plot(GaussianVariogram())
```

### Exponential

```math
\gamma(h) = (s - n) \left[1 - \exp\left(-3\left(\frac{h}{r}\right)\right)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
ExponentialVariogram
```

```@example variograms
Mke.plot(ExponentialVariogram())
```

### Matern

```math
\gamma(h) = (s - n) \left[1 - \frac{2^{1-\nu}}{\Gamma(\nu)} \left(\sqrt{2\nu}\frac{h}{r}\right)^\nu K_\nu\left(\sqrt{2\nu}\frac{h}{r}\right)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
MaternVariogram
```

```@example variograms
Mke.plot(MaternVariogram())
```

### Spherical

```math
\gamma(h) = (s - n) \left[\left(\frac{3}{2}\left(\frac{h}{r}\right) + \frac{1}{2}\left(\frac{h}{r}\right)^3\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
SphericalVariogram
```

```@example variograms
Mke.plot(SphericalVariogram())
```

### Cubic

```math
\gamma(h) = (s - n) \left[\left(7\left(\frac{h}{r}\right)^2 - \frac{35}{4}\left(\frac{h}{r}\right)^3 + \frac{7}{2}\left(\frac{h}{r}\right)^5 - \frac{3}{4}\left(\frac{h}{r}\right)^7\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
CubicVariogram
```

```@example variograms
Mke.plot(CubicVariogram())
```

### Pentaspherical

```math
\gamma(h) = (s - n) \left[\left(\frac{15}{8}\left(\frac{h}{r}\right) - \frac{5}{4}\left(\frac{h}{r}\right)^3 + \frac{3}{8}\left(\frac{h}{r}\right)^5\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
PentasphericalVariogram
```

```@example variograms
Mke.plot(PentasphericalVariogram())
```

### Power

```math
\gamma(h) = sh^a + n \cdot \1_{(0,\infty)}(h)
```

```@docs
PowerVariogram
```

```@example variograms
Mke.plot(PowerVariogram())
```

### Sine hole

```math
\gamma(h) = (s - n) \left[1 - \frac{\sin(\pi h / r)}{\pi h / r}\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
SineHoleVariogram
```

```@example variograms
Mke.plot(SineHoleVariogram())
```

### Nugget

```math
\gamma(h) = n \cdot \1_{(0,\infty)}(h)
```

```@docs
NuggetEffect
```

```@example variograms
Mke.plot(NuggetEffect(1.0))
```

### Circular

```math
\gamma(h) = (s - n) \left[\left(1 - \frac{2}{\pi} \cos^{-1}\left(\frac{h}{r}\right) + \frac{2h}{\pi r} \sqrt{1 - \frac{h^2}{r^2}} \right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
CircularVariogram
```

```@example variograms
Mke.plot(CircularVariogram())
```

## Anisotropy

Anisotropic models are easily obtained by defining an ellipsoid metric in
place of the default Euclidean metric as shown in the following example.
First, we create an ellipsoid that specifies the ranges and angles of
rotation:

```@example variograms
ellipsoid = MetricBall((3.0, 2.0, 1.0), RotZXZ(0.0, 0.0, 0.0))
```

All rotations from [Rotations.jl](https://github.com/JuliaGeometry/Rotations.jl)
are supported as well as the following additional rotations from commercial
geostatistical software:

```@docs
DatamineAngles
VulcanAngles
GslibAngles
```

We pass the ellipsoid as the first argument to the variogram model
instead of specifying a single `range` with a keyword argument:

```@example variograms
GaussianVariogram(ellipsoid, sill=2.0)
```

To illustrate the concept, consider the following 2D data set:

```@example variograms
using Random # hide
Random.seed!(2000) # hide

𝒟 = georef((Z=rand(50),), 100rand(2, 50))

viz(𝒟.geometry, color = 𝒟.Z)
```

and the corresponding estimation problem on a Cartesian grid:

```@example variograms
problem = EstimationProblem(𝒟, CartesianGrid(100, 100), :Z)
```

We solve the problem with different ellipsoids by varying the angle of
rotation from ``0`` to ``2\pi`` clockwise:

```@example variograms
anim = @animate for θ in range(0, stop=2π, length=10)
  # ellipsoid rotated clockwise by angle θ
  e = MetricBall((20.,5.), Angle2d(θ))

  # anisotropic variogram model
  γ = GaussianVariogram(e)

  # solve the problem with Kriging
  sol = solve(problem, Kriging(:Z => (variogram=γ,)))

  # plot current frame
  plot(sol)
end
```

## Nesting

A nested variogram model
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

# nested model with matrix coefficients
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