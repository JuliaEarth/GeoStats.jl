# Validation

GeoStats.jl was designed to, among other things, facilitate rigorous scientific
comparison of different geostatistical solvers in the literature. As a user of
geostatistics, you may be interested in applying various solvers on a given data
set and pick the ones with best performance. As a researcher in the field, you may
be interested in benchmarking your new algorithm against other established methods.

Below is the list of currenlty implemented (spatial) validation methods.

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
