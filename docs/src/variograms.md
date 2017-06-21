# Variograms

```math
\newcommand{\x}{\boldsymbol{x}}
\newcommand{\1}{\mathbb{1}}
```

In an intrinsically stationary isotropic model, the variogram is only a function of
the distance between any two points ``\x_1,\x_2 \in \mathbb{R}^m``:

```math
\gamma(\x_1,\x_2) = \gamma(||\x_1 - \x_2||) = \gamma(h)
```

The same holds for the covariance, which is directly related ``\gamma(h) = cov(0) - cov(h)``.
This package implements a few commonly used and other more excentric stationary models:

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

See the Wikipedia page on [Matérn covariance functions](https://en.wikipedia.org/wiki/Mat%C3%A9rn_covariance_function).

```@docs
MaternVariogram
```
