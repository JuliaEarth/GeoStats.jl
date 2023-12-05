# Fitting variograms

```@example variofit
using GeoStats # hide
import CairoMakie as Mke # hide
```

## Overview

Fitting theoretical variograms to empirical observations is an important
modeling step to ensure valid mathematical models of spatial continuity.
Given an empirical variogram, the `fit` function can be used to perform the fit:

```@docs
Variography.fit(::Type{Variogram}, ::EmpiricalVariogram, ::VariogramFitAlgo)
```

## Example

```@example variofit
# sinusoidal data
𝒟 = georef((Z=[sin(i/2) + sin(j/2) for i in 1:50, j in 1:50],))

# empirical variogram
g = EmpiricalVariogram(𝒟, :Z, maxlag = 25.)

Mke.plot(g)
```

We can fit specific models to the empirical variogram:

```@example variofit
γ = Variography.fit(SineHoleVariogram, g)

Mke.plot(g)
Mke.plot!(γ, maxlag = 25.)
Mke.current_figure()
```

or let the framework find the model with minimum error:

```@example variofit
γ = Variography.fit(Variogram, g)

Mke.plot(g)
Mke.plot!(γ, maxlag = 25.)
Mke.current_figure()
```

which should be a [`SineHoleVariogram`](@ref) given that the synthetic data
of this example is sinusoidal.

Optionally, we can specify a weighting function to give different weights to the lags:

```@example variofit
γ = Variography.fit(SineHoleVariogram, g, h -> exp(-h))

Mke.plot(g)
Mke.plot!(γ, maxlag = 25.)
Mke.current_figure()
```

## Methods

### Weighted least squares

```@docs
WeightedLeastSquares
```
