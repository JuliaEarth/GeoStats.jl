# Theoretical variograms

In an intrinsic isotropic model, the variogram is only a function of the
distance between any two points ``\x_1,\x_2 \in \R^m``:

```math
\gamma(\x_1,\x_2) = \gamma(||\x_1 - \x_2||) = \gamma(h)
```

Under the additional assumption of 2nd-order stationarity, the well-known
covariance is directly related via ``\gamma(h) = cov(0) - cov(h)``. Anisotropic
models are easily obtained by defining an ellipsoid distance in place of the Euclidean
distance. For a list of available distances, please see
[Distances.jl](https://github.com/JuliaStats/Distances.jl).

This package implements a few commonly used and other more exotic variogram models.
Most of these models share a set of default parameters (e.g. `sill=1`, `range=1`,
`distance=Euclidean()`). Some of them have extra parameters that can be set with
keyword arguments:

```@example variograms
using GeoStats # hide
using Plots # hide
MaternVariogram(order=1.) # set order of Bessel function
```

Additionally, a nested variogram model
``\gamma(h) = c_1\cdot\gamma_1(h) + c_2\cdot\gamma_2(h) + \cdots + c_n\cdot\gamma_n(h)``
can be constructed from multiple variogram models, including matrix coefficients:

```@example variograms
γ₁ = GaussianVariogram()
γ₂ = ExponentialVariogram()

# nested model
γ = [1.0 0.0; 0.0 1.0] * γ₁ + [2.0 0.5; 0.5 3.0] * γ₂
```

The individual structures can be recovered in canonical form with the
[`structures`](@ref) function:

```@docs
structures
```

and the 2nd-order stationarity property can be checked with the
[`isstationary`](@ref) function:

```@docs
isstationary
```

Geometric anisotropy can be specified as a distance using the
[`aniso2distance`](@ref) function:

```@docs
aniso2distance
```

## Gaussian

```math
\gamma(h) = (s - n) \left[1 - \exp\left(-3\left(\frac{h}{r}\right)^2\right)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
GaussianVariogram
```

```@example variograms
plot(GaussianVariogram())
```

## Exponential

```math
\gamma(h) = (s - n) \left[1 - \exp\left(-3\left(\frac{h}{r}\right)\right)\right] + n \cdot \1_{(0,\infty)}(h)

```

```@docs
ExponentialVariogram
```

```@example variograms
plot(ExponentialVariogram())
```

## Matern

```math
\gamma(h) = (s - n) \left[1 - \frac{2^{1-\nu}}{\Gamma(\nu)} \left(\sqrt{2\nu}\frac{h}{r}\right)^\nu K_\nu\left(\sqrt{2\nu}\frac{h}{r}\right)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
MaternVariogram
```

```@example variograms
plot(MaternVariogram())
```

## Spherical

```math
\gamma(h) = (s - n) \left[\left(\frac{3}{2}\left(\frac{h}{r}\right) + \frac{1}{2}\left(\frac{h}{r}\right)^3\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
SphericalVariogram
```

```@example variograms
plot(SphericalVariogram())
```

## Cubic

```math
\gamma(h) = (s - n) \left[\left(7\left(\frac{h}{r}\right)^2 - \frac{35}{4}\left(\frac{h}{r}\right)^3 + \frac{7}{2}\left(\frac{h}{r}\right)^5 - \frac{3}{4}\left(\frac{h}{r}\right)^7\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
CubicVariogram
```

```@example variograms
plot(CubicVariogram())
```

## Pentaspherical

```math
\gamma(h) = (s - n) \left[\left(\frac{15}{8}\left(\frac{h}{r}\right) - \frac{5}{4}\left(\frac{h}{r}\right)^3 + \frac{3}{8}\left(\frac{h}{r}\right)^5\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
PentasphericalVariogram
```

```@example variograms
plot(PentasphericalVariogram())
```

## Power

```math
\gamma(h) = sh^a + n \cdot \1_{(0,\infty)}(h)
```

```@docs
PowerVariogram
```

```@example variograms
plot(PowerVariogram())
```

## Sine hole

```math
\gamma(h) = (s - n) \left[1 - \frac{\sin(\pi h / r)}{\pi h / r}\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
SineHoleVariogram
```

```@example variograms
plot(SineHoleVariogram())
```

## Nugget

```math
\gamma(h) = n \cdot \1_{(0,\infty)}(h)
```

```@docs
NuggetEffect
```

```@example variograms
plot(NuggetEffect(1.0))
```
