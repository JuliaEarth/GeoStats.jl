# Validation

GeoStats.jl was designed to, among other things, facilitate rigorous scientific
comparison of different geostatistical solvers in the literature. As a user of
geostatistics, you may be interested in applying various solvers on a given data
set and pick the ones with best performance. As a researcher in the field, you may
be interested in benchmarking your new method against other established methods.

Errors of geostatistical solvers can be estimated on given geostatistical problems:

```@docs
error(::Any, ::Any, ::ErrorEstimationMethod)
```

Below is the list of currently implemented error estimation methods.

## Leave-one-out

```@docs
LeaveOneOut
```

## Leave-ball-out

```@docs
LeaveBallOut
```

## K-fold

```@docs
KFoldValidation
```

## Block

```@docs
BlockValidation
```

## Weighted

```@docs
WeightedValidation
```

## Density-ratio

```@docs
DensityRatioValidation
```
