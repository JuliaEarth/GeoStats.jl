# Statistics

The term *spatial statistics* can refer to statistics computed with samples
collected in a spatial domain (a.k.a. spatial data), or to statistics computed
with multiple realizations of a random field (a.k.a. ensemble).

## Data

The following statistics have spatial semantics (i.e. make use of spatial coordinates),
and as such, approximate better spatial variables when compared to their non-spatial
counterparts:

```@docs
EmpiricalHistogram
mean(::AbstractData)
var(::AbstractData)
```

## Ensemble

A set of geostatistical realizations of a random field represents a probability
distribution. It is often useful to compute summary statistics with this set
or ensemble:

```@docs
mean(::SimulationSolution)
var(::SimulationSolution)
quantile(::SimulationSolution, ::Number)
```
