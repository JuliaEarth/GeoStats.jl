# Distances

```math
\newcommand{\x}{\boldsymbol{x}}
\newcommand{\y}{\boldsymbol{y}}
```

A set of commonly used distance functions is provided in this package:

- Euclidean
- Ellipsoid

These can be used to model anisotropy (e.g. ellipsoid distance), to perform
geostatistical simulation on non-Euclidean coordinate systems (e.g. geodesic
distance between latitude/longitude marks), or to handle arbitrary manifolds.

## Euclidean

```math
d(\x,\y) = \sqrt{(\x-\y)^\top (\x-\y)}
```

```@docs
EuclideanDistance
```

## Ellipsoid

```math
d(\x,\y) = \sqrt{(\x-\y)^\top \boldsymbol{A} (\x-\y)}
```

```@docs
EllipsoidDistance
```
