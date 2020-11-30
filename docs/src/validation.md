# Validation

GeoStats.jl was designed to, among other things, facilitate rigorous scientific
comparison of different geostatistical solvers in the literature. As a user of
geostatistics, you may be interested in applying various solvers on a given data
set and pick the ones with best performance. As a researcher in the field, you may
be interested in benchmarking your new method against other established methods.

Errors of geostatistical solvers can be estimated on given geostatistical problems:

```@docs
GeoStatsBase.error
```

Below is the list of currently implemented error estimation methods.

## Leave-one-out validation

```@docs
LeaveOneOut
```

## Leave-ball-out validation

```@docs
LeaveBallOut
```

## Cross-validation

```@docs
CrossValidation
```

## Block cross-validation

```@docs
BlockCrossValidation
```

## Weighted cross-validation

```@docs
WeightedCrossValidation
```

## Density-ratio validation

```@docs
DensityRatioValidation
```
