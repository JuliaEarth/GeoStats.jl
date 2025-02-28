# Partitioning

```@example partitioning
using GeoStats # hide
import CairoMakie as Mke # hide
```

## Overview

It is often useful to group geospatial data based on geometric criteria,
instead of statistical criteria in [Clustering](clustering.md) methods.
We provide various partitioning methods for geotables or domains via the
[`partition`](@ref) function:

```@docs
partition
PartitionMethod
```

We illustrate this concept with the [`BisectFractionPartition`](@ref) method:

```@example partitioning
# random image with 100x100 pixels
gtb = georef((; z=rand(100, 100)))

# 70%/30% partition perpendicular to (1.0, 1.0) direction
Π = partition(gtb, BisectFractionPartition((1.0, 1.0), fraction=0.7))
```

The result of a partitioning method is a lazy indexable collection of
geotables or domains:

```@example partitioning
Π[1] |> viewer
```

```@example partitioning
Π[2] |> viewer
```

In this specific example, we could have used the [`geosplit`](@ref)
utility function, which simplifies the syntax further:

```@docs
geosplit
```

```@example partitioning
geosplit(gtb, 0.7, (1.0, 1.0))
```

## Methods

### Uniform

```@docs
UniformPartition
```

### Fraction

```@docs
FractionPartition
```

### Block

```@docs
BlockPartition
```

### Bisect-Point

```@docs
BisectPointPartition
```

### Bisect-Fraction

```@docs
BisectFractionPartition
```

### Ball

```@docs
BallPartition
```

### Plane

```@docs
PlanePartition
```

### Direction

```@docs
DirectionPartition
```

### IndexPredicate

```@docs
IndexPredicatePartition
```

### PointPredicate

```@docs
PointPredicatePartition
```

### Product

```@docs
ProductPartition
```

### Hierarchical

```@docs
HierarchicalPartition
```
