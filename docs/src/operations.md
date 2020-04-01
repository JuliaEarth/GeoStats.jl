# Spatial operations

Below is a list of spatial operations implemented in the GeoStats.jl framework.

## Partitioning

```@docs
UniformPartitioner
FractionPartitioner
SLICPartitioner
BlockPartitioner
BisectPointPartitioner
BisectFractionPartitioner
BallPartitioner
PlanePartitioner
DirectionPartitioner
VariablePartitioner
PredicatePartitioner
SpatialPredicatePartitioner
ProductPartitioner
HierarchicalPartitioner
```

## Weighting

```@docs
BlockWeighter
DensityRatioWeighter
```

## Sampling

```@docs
UniformSampler
BallSampler
WeightedSampler
```

## Filtering

```@docs
UniqueCoordsFilter
```

## Joining

```@docs
VariableJoiner
```

## Searching

```@docs
NeighborhoodSearcher
NearestNeighborSearcher
BoundedSearcher
```

## Covering

```@docs
RectangleCoverer
```

## Discretizing

```@docs
RegularGridDiscretizer
```

## Statistics

The term *spatial statistics* can refer to statistics computed with samples collected
in a spatial domain (a.k.a. spatial data), or to statistics computed with multiple
realizations of a random field (e.g. multiple maps).

### Statistics from spatial data

The following statistics have spatial semantics (i.e. make use of spatial coordinates),
and as such, approximate better spatial variables when compared to their non-spatial
counterparts:

```@docs
EmpiricalHistogram
```

### Statistics from random field

A set of geostatistical realizations of a random field represents a probability
distribution. It is often useful to compute summary statistics with this set
(e.g. location-wise mean and variance) and try understand spatial trends. In
GeoStats.jl a set of realizations is stored in a `SimulationSolution` object.
Currently, the following statistics are defined:

```@docs
mean(::SimulationSolution)
var(::SimulationSolution)
quantile(::SimulationSolution, ::Real)
```
