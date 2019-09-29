# Solver comparisons

GeoStats.jl was designed to, among other things, facilitate rigorous scientific
comparison of different geostatistical solvers in the literature. As a user of
geostatistics, you may be interested in applying various solvers on a given data
set and pick the ones with best performance. As a researcher in the field, you may
be interested in benchmarking your new algorithm against other established methods.

Typically, this task would demand a great amount of time from the practitioner, which
would become responsible for pre/post processing the data himself/herself before it
can be fed into the software. But that is not the only issue, quantitative comparison
of geostatistical solvers is an area of active research. Although a few comparison
methods exist, their implementation is not necessarily straighforward.

In this project, solvers can be compared without effort. Below is a list of currenlty
implemented comparison methods. For examples of usage, please consult the
[GeoStatsTutorials](https://github.com/juliohm/GeoStatsTutorials) repository.

## Cross-validation

```@docs
CrossValidation
```

## Block Cross-Validation

```@docs
BlockCrossValidation
```

## Leave-Ball-Out Validation

```@docs
LeaveBallOut
```
