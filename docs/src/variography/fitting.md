# Fitting variograms

## Overview

Fitting theoretical variograms to empirical observations is an important
modeling step to ensure valid mathematical models of spatial continuity.
Given an empirical variogram, the `fit` function can be used to perform the fit:

```@docs
fit(::Type{Variogram}, ::EmpiricalVariogram, ::VariogramFitAlgo)
```

## Example

```@example variofit
using GeoStats # hide
using Plots # hide
using GeoStatsPlots # hide
gr(size=(800,400)) # hide

# sinusoidal data
𝒟 = georef((Z=[sin(i/2) + sin(j/2) for i in 1:50, j in 1:50],))

# empirical variogram
g = EmpiricalVariogram(𝒟, :Z, maxlag=25.)

plot(g)
```

We can fit specific models to the empirical variogram:

```@example variofit
γ = fit(SineHoleVariogram, g)

plot(g); plot!(γ)
```

or let GeoStats.jl find the model with minimum error:

```@example variofit
γ = fit(Variogram, g)

plot(g); plot!(γ)
```

which should be a [`SineHoleVariogram`](@ref) given that the synthetic data
of this example is sinusoidal.

Optionally, we can specify a weighting function to give different weights to the lags:

```@example variofit
γ = fit(SineHoleVariogram, g, h -> exp(-h))

plot(g); plot!(γ)
```

## Methods

### Weighted least squares

```@docs
WeightedLeastSquares
```
