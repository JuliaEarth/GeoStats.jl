# Spatial statistics

A set of geostatistical realizations represents a probability
distribution. It is often useful to compute summary statistics
with this set (e.g. location-wise mean and variance) and try
understand spatial trends. In GeoStats.jl a set of realizations
is stored in a `SimulationSolution` object. Currently, the
following statistics are defined:

## Mean

```@docs
GeoStatsDevTools.mean(::SimulationSolution)
```

## Variance

```@docs
GeoStatsDevTools.var(::SimulationSolution)
```

## Quantile

```@docs
GeoStatsDevTools.quantile(::SimulationSolution, ::Real)
```
