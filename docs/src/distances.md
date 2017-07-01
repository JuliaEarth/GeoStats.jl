# Distances

```math
\newcommand{\x}{\boldsymbol{x}}
\newcommand{\y}{\boldsymbol{y}}
```

A set of commonly used distance functions is provided in this package
for use in geostatistical algorithms. They can be passed to
[variograms](variograms.md) in order to:

- Model anisotropy (e.g. ellipsoid distance)
- Perform geostatistical simulation on non-Euclidean coordinate systems (e.g. haversine distance)
- etc.

## Euclidean

```math
d(\x,\y) = \sqrt{(\x-\y)^\top (\x-\y)}
```

```@docs
EuclideanDistance
```

## Ellipsoid

The ellipsoid distance can be used to model anisotropy. The semiaxes of the
ellipsoid represent correlation lengths that can be rotated and aligned with
target directions.

```math
d(\x,\y) = \sqrt{(\x-\y)^\top \boldsymbol{A} (\x-\y)}
```

```@docs
EllipsoidDistance
```

## Haversine

The haversine distance can be used to perform geostatistical simulation
directly on a sphere. It approximates the geodesic distance between two
pairs of latitude/longitude.

```@docs
HaversineDistance
```
