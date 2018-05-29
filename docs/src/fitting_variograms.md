# Fitting variograms

Fitting theoretical variograms to empirical observations is an important
preprocessing step to ensure valid mathematical models of spatial continuity
for posterior estimation/simulation with variogram-based methods such as
Kriging and sequential Gaussian simulation.

Given an empirical variogram, the `fit` function can be used to perform the fit:

```@docs
fit
```

Currently the following fitting methods are implemented:

## Weighted least squares

```@docs
WeightedLeastSquares
```
