# Fitting variograms

Fitting theoretical variograms to empirical observations is an important
preprocessing step to ensure valid mathematical models of spatial continuity.
Given an empirical variogram, the `fit` function can be used to perform the fit:

```@docs
fit(::Type{Variogram}, ::EmpiricalVariogram, ::VariogramFitAlgo)
```

Currently the following fitting methods are implemented:

## Weighted least squares

```@docs
WeightedLeastSquares
```
