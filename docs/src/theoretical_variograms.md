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

Under the additional assumption of 2nd order stationarity, the well-known
covariance is directly related via ``\gamma(h) = cov(0) - cov(h)``. Anisotropic
models are easily obtained by defining an ellipsoid distance in place of the Euclidean
distance. For a list of available distances, please see [Distance functions](distances.md).

This package implements a few commonly used and other more excentric variogram models:

- Gaussian
- Spherical
- Exponential
- Matérn (see [Matérn covariance functions](https://en.wikipedia.org/wiki/Mat%C3%A9rn_covariance_function))

They all share the same default parameters of `sill=1`, `range=1`, `nugget=0`, `distance=EuclideanDistance()`.
Some of them have extra parameters that can be set with keyword arguments:

```julia
GaussianVariogram(nugget=.1) # add nugget effect
MaternVariogram(order=1) # set order of Bessel function
```

Additionally, a composite (additive) variogram model ``\gamma(h) = \gamma_1(h) + \gamma_2(h) + \cdots \gamma_n(h)``
can be constructed from a list of variogram models:

```julia
CompositeVariogram(GaussianVariogram(), ExponentialVariogram())
```

Like the other variogram models, a composite variogram ``\gamma`` can be evaluated as an isotropic model
``\gamma(h)`` or as a model with a custom distance implicitly defined by taking into account its individual
components ``\gamma(\x_1,\x_2)``.

## Gaussian

```math
\gamma(h) = (s - n) \left[1 - \exp\left(-\left(\frac{h}{r}\right)^2\right)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
GaussianVariogram
```

## Spherical

```math
\gamma(h) = (s - n) \left[\left(\frac{3}{2}\left(\frac{h}{r}\right) + \frac{1}{2}\left(\frac{h}{r}\right)^3\right) \cdot \1_{(0,r)}(h) + \1_{[r,\infty)}(h)\right] + n \cdot \1_{(0,\infty)}(h)
```

```@docs
SphericalVariogram
```

## Exponential

```math
\gamma(h) = (s - n) \left[1 - \exp\left(-\frac{h}{r}\right)\right] + n \cdot \1_{(0,\infty)}(h)

```

```@docs
ExponentialVariogram
```

## Matern

```math
\gamma(h) = (s - n) \left[1 - \frac{2^{1-\nu}}{\Gamma(\nu)} \left(\sqrt{2\nu}\frac{h}{r}\right)^\nu K_\nu\left(\sqrt{2\nu}\frac{h}{r}\right)\right]
```

```@docs
MaternVariogram
```

## Composite

```@docs
CompositeVariogram
```
