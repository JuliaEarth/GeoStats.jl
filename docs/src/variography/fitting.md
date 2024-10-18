# Fitting variograms

```@example variofit
using GeoStats # hide
import CairoMakie as Mke # hide
```

## Overview

Fitting theoretical variograms to empirical observations is an important
modeling step to ensure valid mathematical models of geospatial continuity.
Given an empirical variogram, the following function can be used to fit models:

```@docs
GeoStatsFunctions.fit
```

## Example

```@example variofit
# sinusoidal data
𝒟 = georef((Z=[sin(i/2) + sin(j/2) for i in 1:50, j in 1:50],))

# empirical variogram
g = EmpiricalVariogram(𝒟, :Z, maxlag = 25u"m")

varioplot(g)
```

We can fit specific models to the empirical variogram:

```@example variofit
γ = GeoStatsFunctions.fit(SineHoleVariogram, g)

varioplot(g)
varioplot!(γ, maxlag = 25u"m")
Mke.current_figure()
```

or let the framework find the model with minimum error:

```@example variofit
γ = GeoStatsFunctions.fit(Variogram, g)

varioplot(g)
varioplot!(γ, maxlag = 25u"m")
Mke.current_figure()
```

which should be a [`SineHoleVariogram`](@ref) given that the synthetic data
of this example is sinusoidal.

Optionally, we can specify a weighting function to give different weights to the lags:

```@example variofit
γ = GeoStatsFunctions.fit(SineHoleVariogram, g, h -> 1 / h^2)

varioplot(g)
varioplot!(γ, maxlag = 25u"m")
Mke.current_figure()
```

## Methods

### Weighted least squares

```@docs
WeightedLeastSquares
```
