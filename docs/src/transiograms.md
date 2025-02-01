# Transiograms

```@example transiograms
using GeoStats # hide
import CairoMakie as Mke # hide
```

## Empirical transiograms

Transiograms of categorical variables are matrix-valued functions ``t_{ab}(h)``
that measure the transition probability from categorical value ``a`` to categorical
value ``b`` at a given lag ``h \in \R``. They are often used for the simulation of
Markov processes in more than one dimension.

The Carle's estimator of the empirical transiogram is given by

```math
\widehat{t_{ab}}(h) = \frac{\sum_{(i,j) \in N(h)} {I_a}_i \cdot {I_b}_j}{\sum_{(i,j) \in N(h)} {I_a}_i}
```

where ``N(h) = \left\{(i,j) \mid ||\p_i - \p_j|| = h\right\}`` is the set
of pairs of locations at a distance ``h``, and where ``I_a`` and ``I_b``
are the indicator variables for categorical values (or levels) ``a`` and ``b``,
respectively.

Transiograms can be plotted with the following options:

```@docs
transioplot
```

### (Omini)directional transiograms

```@docs
EmpiricalTransiogram
DirectionalTransiogram
PlanarTransiogram
```

Consider the following categorical image:

```@example transiograms
using GeoStatsImages

img = geostatsimage("Gaussian30x10")

Z = [z < 0 ? 1 : 2 for z in img.Z]

cat = georef((; Z=Z), img.geometry)

cat |> viewer
```

We can estimate the ominidirectional transiogram with

```@example transiograms
t = EmpiricalTransiogram(cat, :Z, maxlag = 50.)

transioplot(t)
```

### Empirical transioplanes

Transiograms estimated along all directions in a given plane of reference are
called transioplanes.

```@docs
EmpiricalTransioplane
```

The transioplane is plotted on a polar axis for all lags and angles:

```@example transiograms
t = EmpiricalTransioplane(cat, :Z, maxlag = 50.)

planeplot(t)
```

## Theoretical transiograms

We provide various theoretical transiogram models from the literature, which can
can be combined with ellipsoid distances to model geometric anisotropy.

### Models

#### Linear

```@docs
LinearTransiogram
```

```@example transiograms
transioplot(LinearTransiogram())
```

#### Gaussian

```@docs
GaussianTransiogram
```

```@example transiograms
transioplot(GaussianTransiogram())
```

#### Spherical

```@docs
SphericalTransiogram
```

```@example transiograms
transioplot(SphericalTransiogram())
```

#### Exponential

```@docs
ExponentialTransiogram
```

```@example transiograms
transioplot(ExponentialTransiogram())
```

#### MatrixExponential

```@docs
MatrixExponentialTransiogram
```

```@example transiograms
transioplot(MatrixExponentialTransiogram((1.0u"m", 1.0u"m"), (0.5, 0.5)))
```

#### PiecewiseLinear

```@docs
PiecewiseLinearTransiogram
```
