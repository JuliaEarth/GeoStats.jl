# Distance functions

A set of commonly used distance functions is provided in this package
for use in geostatistical algorithms. They can be passed to
[variograms](theoretical_variograms.md) in order to:

- Model anisotropy (e.g. ellipsoid distance)
- Perform geostatistical simulation on non-Euclidean coordinate systems (e.g. haversine distance)

Custom distance functions are particularly useful if 3D locations are projected on a 2D map by means
of a non-trivial transformation. In this case, a geodesic distance can be defined to properly account
for spatial distortions at large scales.

## Euclidean

```math
\newcommand{\x}{\boldsymbol{x}}
\newcommand{\y}{\boldsymbol{y}}
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
