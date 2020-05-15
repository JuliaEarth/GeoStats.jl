# Partitioning

## Overview

A spatial object can be partitioned into various sub-objects:

```@docs
partition(::AbstractSpatialObject, ::AbstractPartitioner)
```

Other utility functions are available, which are implemented with the general
`partition` function:

```@docs
split(::AbstractSpatialObject, ::Real)
```

```@docs
groupby(::AbstractData, ::Symbol)
```

## Example

```@example
using GeoStats # hide
using LinearAlgebra # hide
using Plots # hide
gr(format=:svg) # hide

Z = [norm([i,j]) for i in 1:100, j in 1:100]
Ω = RegularGridData{Float64}(OrderedDict(:Z=>Z))

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
