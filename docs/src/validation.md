# Validation

GeoStats.jl was designed to, among other things, facilitate rigorous scientific
comparison of different geostatistical solvers in the literature. As a user of
geostatistics, you may be interested in applying various solvers on a given data
set and pick the ones with best performance. As a researcher in the field, you may
be interested in benchmarking your new method against other established methods.

Errors of geostatistical solvers can be estimated on given geostatistical problems:

```@docs
error(::AbstractSolver, ::AbstractProblem, ::AbstractErrorEstimator)
```

Below is the list of currently implemented error estimation methods.

## Cross-validation

```@docs
CrossValidation
```

## Block cross-validation

```@docs
BlockCrossValidation
```

## Leave-ball-out validation

```@docs
LeaveBallOut
```

## Weighted cross-validation

```@docs
WeightedCrossValidation
```

## Weighted hold-out validation

```@docs
WeightedHoldOut
```

## Weighted bootstrap validation

```@docs
WeightedBootstrap
```

## Density-ratio validation

```@docs
DensityRatioValidation
```

## Ball-sample validation

```@docs
BallSampleValidation
```
