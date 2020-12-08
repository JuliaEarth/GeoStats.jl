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

Π = partition(Ω, BlockPartition(10.,10.))

plot(plot(Ω), plot(Π))
```

## Methods

```@docs
RandomPartition
FractionPartition
SLICPartition
BlockPartition
BisectPointPartition
BisectFractionPartition
BallPartition
PlanePartition
DirectionPartition
VariablePartition
PredicatePartition
SPredicatePartition
ProductPartition
HierarchicalPartition
```
