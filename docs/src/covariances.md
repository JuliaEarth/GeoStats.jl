# Covariances

```@example covariances
using GeoStats # hide
import CairoMakie as Mke # hide
```

## Theoretical covariances

When [variograms](variograms.md) reach a finite sill, it is possible to work with
equivalent covariance functions. These functions produce numerically stable linear
systems, and are preferred by researchers in other scientific fields.

!!! note

    Our [`Kriging`](@ref) implementation converts variograms into covariances
    internally (when that is possible) to avoid numerical instabilities. This
    conversion is efficient thanks to the rich type system, and gives users the
    freedom to choose whichever function representation they prefer.

### GaussianCovariance

```@docs
GaussianCovariance
```

```@example covariances
funplot(GaussianCovariance())
```

### SphericalCovariance

```@docs
SphericalCovariance
```

```@example covariances
funplot(SphericalCovariance())
```

### ExponentialCovariance

```@docs
ExponentialCovariance
```

```@example covariances
funplot(ExponentialCovariance())
```

### MaternCovariance

```@docs
MaternCovariance
```

```@example covariances
funplot(MaternCovariance())
```

### CubicCovariance

```@docs
CubicCovariance
```

```@example covariances
funplot(CubicCovariance())
```

### PentaSphericalCovariance

```@docs
PentaSphericalCovariance
```

```@example covariances
funplot(PentaSphericalCovariance())
```

### SineHoleCovariance

```@docs
SineHoleCovariance
```

```@example covariances
funplot(SineHoleCovariance())
```

### CircularCovariance

```@docs
CircularCovariance
```

```@example covariances
funplot(CircularCovariance())
```
