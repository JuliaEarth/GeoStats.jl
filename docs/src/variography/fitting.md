# Fitting variograms

## Overview

Fitting theoretical variograms to empirical observations is an important
modeling step to ensure valid mathematical models of spatial continuity.
Given an empirical variogram, the `fit` function can be used to perform the fit:

```@docs
fit(::Type{Variogram}, ::EmpiricalVariogram, ::VariogramFitAlgo)
```

## Example

In this example we generate data from a known theoretical model and fit
other models to the data. First, we select a single model and evaluate it
at different lags to create a synthetic empirical variogram:

```@example variofit
using GeoStats # hide
using Plots # hide
# create data from a model
γ = SphericalVariogram()
x = range(0, stop=3, length=20)
y = γ.(x)
n = 20:-1:1

# synthetic empirical variogram
g = EmpiricalVariogram(x, y, n)

plot(g)
```

We can then fit different models to the empirical variogram:

```@example variofit
γs = [fit(V, g) for V in [GaussianVariogram, ExponentialVariogram, MaternVariogram]]

# plot all models
p = plot(g)
for γ in γs
  plot!(γ, maxlag=3.)
end
p
```

Alternatively, we can let GeoStats.jl find the model with minimum error:

```@example variofit
γₒ = fit(Variogram, g)
```

## Methods

### Weighted least squares

```@docs
WeightedLeastSquares
```
