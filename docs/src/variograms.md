# Variograms

```math
\newcommand{\x}{\boldsymbol{x}}
```

In a stationary isotropic model, the variogram is only a function of the distance
between any two points ``\x_1,\x_2 \in \mathbb{R}^m``:

```math
\gamma(\x_1,\x_2) = \gamma(||\x_1 - \x_2||) = \gamma(h)
```

The same holds for the covariance, which is directly related ``\gamma(h) = cov(0) - cov(h)``.
This package implements a few commonly used stationary models:

## Gaussian

```math
cov(h) = (s - n) \cdot \exp\left(-\left(\frac{h}{r}\right)^2\right)
```

```@docs
GaussianCovariance
```

## Spherical

```math
cov(h) =
\begin{cases}
(s - n) (1 - \frac{3}{2}\left(\frac{h}{r}\right) + \frac{1}{2}\left(\frac{h}{r}\right)^3) & \text{if } h \leq r \\
0 & \text{otherwise}
\end{cases}
```

```@docs
SphericalCovariance
```

## Exponential

```math
cov(h) = (s - n) \cdot \exp\left(-\frac{h}{r}\right)
```

```@docs
ExponentialCovariance
```
