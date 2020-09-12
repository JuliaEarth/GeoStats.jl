# Partitioning

## Overview

A spatial object can be partitioned into various sub-objects:

```@docs
GeoStatsBase.partition
```

## Example

```@example
using GeoStats # hide
using LinearAlgebra # hide
using Plots # hide
gr(format=:png) # hide

Ω = georef((Z=[norm([i,j]) for i in 1:100, j in 1:100],))

Π = partition(Ω, BlockPartitioner(10.,10.))

plot(plot(Ω), plot(Π))
```

## Methods

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
