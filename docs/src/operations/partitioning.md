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
