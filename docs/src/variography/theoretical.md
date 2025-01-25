# Theoretical variograms

```@example theoreticalvariogram
using GeoStats # hide
import CairoMakie as Mke # hide
```

We provide various theoretical variogram models from the literature, which can
be combined with ellipsoid distances to model geometric anisotropy and nested
with scalars or matrix coefficients to express multivariate relations.

## Models

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

```@example theoreticalvariogram
varioplot(GaussianVariogram())
```

### Spherical

```math
\gamma(h) = (s - n) \left[\left(\frac{3}{2}\left(\frac{h}{r}\right) + \frac{1}{2}\left(\frac{h}{r}\right)^3\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
SphericalVariogram
```

```@example theoreticalvariogram
varioplot(SphericalVariogram())
```

### Exponential

```math
\gamma(h) = (s - n) \left[1 - \exp\left(-3\left(\frac{h}{r}\right)\right)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
ExponentialVariogram
```

```@example theoreticalvariogram
varioplot(ExponentialVariogram())
```

### Matern

```math
\gamma(h) = (s - n) \left[1 - \frac{2^{1-\nu}}{\Gamma(\nu)} \left(\sqrt{2\nu}\ 3\left(\frac{h}{r}\right)\right)^\nu K_\nu\left(\sqrt{2\nu}\ 3\left(\frac{h}{r}\right)\right)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
MaternVariogram
```

```@example theoreticalvariogram
varioplot(MaternVariogram())
```

### Cubic

```math
\gamma(h) = (s - n) \left[\left(7\left(\frac{h}{r}\right)^2 - \frac{35}{4}\left(\frac{h}{r}\right)^3 + \frac{7}{2}\left(\frac{h}{r}\right)^5 - \frac{3}{4}\left(\frac{h}{r}\right)^7\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
CubicVariogram
```

```@example theoreticalvariogram
varioplot(CubicVariogram())
```

### PentaSpherical

```math
\gamma(h) = (s - n) \left[\left(\frac{15}{8}\left(\frac{h}{r}\right) - \frac{5}{4}\left(\frac{h}{r}\right)^3 + \frac{3}{8}\left(\frac{h}{r}\right)^5\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
PentaSphericalVariogram
```

```@example theoreticalvariogram
varioplot(PentaSphericalVariogram())
```

### Sine hole

```math
\gamma(h) = (s - n) \left[1 - \frac{\sin(\pi h / r)}{\pi h / r}\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
SineHoleVariogram
```

```@example theoreticalvariogram
varioplot(SineHoleVariogram())
```

### Circular

```math
\gamma(h) = (s - n) \left[\left(1 - \frac{2}{\pi} \cos^{-1}\left(\frac{h}{r}\right) + \frac{2h}{\pi r} \sqrt{1 - \frac{h^2}{r^2}} \right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
CircularVariogram
```

```@example theoreticalvariogram
varioplot(CircularVariogram())
```

### Power

```math
\gamma(h) = sh^a + n \cdot \1_{(0,\infty)}(h)
```

```@docs
PowerVariogram
```

```@example theoreticalvariogram
varioplot(PowerVariogram())
```

### Nugget

```math
\gamma(h) = n \cdot \1_{(0,\infty)}(h)
```

```@docs
NuggetEffect
```

```@example theoreticalvariogram
varioplot(NuggetEffect(1.0))
```

## Anisotropy

Anisotropic models can be constructed from a list of `ranges` and `rotation`
matrix from [Rotations.jl](https://github.com/JuliaGeometry/Rotations.jl):

```@example theoreticalvariogram
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

```@example theoreticalvariogram
using Random # hide
Random.seed!(2000) # hide

points = rand(Point, 50, crs=Cartesian2D) |> Scale(100)
geotable = georef((Z=rand(50),), points)

viz(geotable.geometry, color = geotable.Z)
```

```@example theoreticalvariogram
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

## Nesting

A nested variogram model
``\gamma(h) = c_1\cdot\gamma_1(h) + c_2\cdot\gamma_2(h) + \cdots + c_n\cdot\gamma_n(h)``
can be constructed from multiple variogram models, including matrix coefficients. The
individual structures can be recovered in canonical form with the [`structures`](@ref)
function:

```@docs
structures
```

```@example theoreticalvariogram
γ₁ = GaussianVariogram(nugget=1, sill=2)
γ₂ = ExponentialVariogram(nugget=2, sill=3)

# nested model with matrix coefficients
γ = [1.0 0.0; 0.0 1.0] * γ₁ + [2.0 0.5; 0.5 3.0] * γ₂

# structures in canonical form
cₒ, c, g = structures(γ)

cₒ # matrix nugget
```

```@example theoreticalvariogram
c # matrix coefficients
```

```@example theoreticalvariogram
g # normalized structures
```