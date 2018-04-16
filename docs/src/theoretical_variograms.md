# Theoretical variograms

```math
\newcommand{\x}{\boldsymbol{x}}
\newcommand{\R}{\mathbb{R}}
\newcommand{\1}{\mathbb{1}}
```

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

This package implements a few commonly used and other more excentric variogram models.
They all share the same default parameters:

- `sill=1`
- `range=1`
- `nugget=0`
- `distance=Euclidean()`

Some of them have extra parameters that can be set with keyword arguments:

```julia
GaussianVariogram(nugget=.1) # set nugget effect
MaternVariogram(order=1) # set order of Bessel function
```

Additionally, a composite (additive) variogram model ``\gamma(h) = \gamma_1(h) + \gamma_2(h) + \cdots \gamma_n(h)``
can be constructed from a list of variogram models:

```julia
γ = GaussianVariogram() + ExponentialVariogram()
```

Like the other variogram models, a composite variogram ``\gamma`` can be evaluated as an isotropic model
``\gamma(h)`` or as a model with a custom distance ``\gamma(\x_1,\x_2)``.

Finally, the 2nd-order stationarity property of a variogram can be checked with the `isstationary` method:

```@docs
isstationary
```

## Gaussian

```math
\gamma(h) = (s - n) \left[1 - \exp\left(-3\left(\frac{h}{r}\right)^2\right)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
GaussianVariogram
```

## Exponential

```math
\gamma(h) = (s - n) \left[1 - \exp\left(-3\left(\frac{h}{r}\right)\right)\right] + n \cdot \1_{(0,\infty)}(h)

```

```@docs
ExponentialVariogram
```

## Matern

```math
\gamma(h) = (s - n) \left[1 - \frac{2^{1-\nu}}{\Gamma(\nu)} \left(\sqrt{2\nu}\frac{h}{r}\right)^\nu K_\nu\left(\sqrt{2\nu}\frac{h}{r}\right)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
MaternVariogram
```

## Spherical

```math
\gamma(h) = (s - n) \left[\left(\frac{3}{2}\left(\frac{h}{r}\right) + \frac{1}{2}\left(\frac{h}{r}\right)^3\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
SphericalVariogram
```

## Cubic

```math
\gamma(h) = (s - n) \left[\left(7\left(\frac{h}{r}\right)^2 - \frac{35}{4}\left(\frac{h}{r}\right)^3 + \frac{7}{2}\left(\frac{h}{r}\right)^5 - \frac{3}{4}\left(\frac{h}{r}\right)^7\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
CubicVariogram
```

## Pentaspherical

```math
\gamma(h) = (s - n) \left[\left(\frac{15}{8}\left(\frac{h}{r}\right) - \frac{5}{4}\left(\frac{h}{r}\right)^3 + \frac{3}{8}\left(\frac{h}{r}\right)^5\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
PentasphericalVariogram
```

## Power

```math
\gamma(h) = sh^a + n \cdot \1_{(0,\infty)}(h)
```

```@docs
PowerVariogram
```

## Sine hole

```math
\gamma(h) = (s - n) \left[1 - \frac{\sin(\pi h / r)}{\pi h / r}\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
SineHoleVariogram
```

## Composite

```@docs
CompositeVariogram
```
