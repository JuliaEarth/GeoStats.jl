# Spatial statistics

A set of geostatistical realizations represents a probability
distribution. It is often useful to compute summary statistics
with this set (e.g. location-wise mean and variance) and try
understand spatial trends. In GeoStats.jl a set of realizations
is stored in a `SimulationSolution` object. Currently, the
following statistics are defined:

## Mean

```@docs
GeoStatsBase.mean(::SimulationSolution)
```

## Variance

```@docs
GeoStatsBase.var(::SimulationSolution)
```

## Quantile

```@docs
GeoStatsBase.quantile(::SimulationSolution, ::Real)
```
