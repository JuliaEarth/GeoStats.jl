# Theoretical transiograms

```@example theoreticaltransiogram
using GeoStats # hide
import CairoMakie as Mke # hide
```

We provide various theoretical transiogram models from the literature, which can
can be combined with ellipsoid distances to model geometric anisotropy.

## Models

### Linear

```@docs
LinearTransiogram
```

```@example theoreticaltransiogram
transioplot(LinearTransiogram())
```

### Gaussian

```@docs
GaussianTransiogram
```

```@example theoreticaltransiogram
transioplot(GaussianTransiogram())
```

### Spherical

```@docs
SphericalTransiogram
```

```@example theoreticaltransiogram
transioplot(SphericalTransiogram())
```

### Exponential

```@docs
ExponentialTransiogram
```

```@example theoreticaltransiogram
transioplot(ExponentialTransiogram())
```

### MatrixExponential

```@docs
MatrixExponentialTransiogram
```

```@example theoreticaltransiogram
transioplot(MatrixExponentialTransiogram((1.0u"m", 1.0u"m"), (0.5, 0.5)))
```

### PiecewiseLinear

```@docs
PiecewiseLinearTransiogram
```
