# Covariances

```@example covariances
using GeoStats # hide
import CairoMakie as Mke # hide
```

## Theoretical covariances

When [variograms](variograms.md) reach a finite sill, it is possible to work with
equivalent covariance functions. These functions produce more numerically stable
linear systems, and are preferred by researchers in other scientific fields.

### Models

#### GaussianCovariance

```@docs
GaussianCovariance
```

#### SphericalCovariance

```@docs
SphericalCovariance
```

#### ExponentialCovariance

```@docs
ExponentialCovariance
```

#### MaternCovariance

```@docs
MaternCovariance
```

#### CubicCovariance

```@docs
CubicCovariance
```

#### PentaSphericalCovariance

```@docs
PentaSphericalCovariance
```

#### SineHoleCovariance

```@docs
SineHoleCovariance
```

#### CircularCovariance

```@docs
CircularCovariance
```
