# Weighting

## Overview

Points or samples in spatial objects can be weighted:

```@docs
weight
```

## Example

```@example
using GeoStats # hide
using LinearAlgebra # hide
using Plots # hide
gr(format=:svg) # hide

Ω = PointSet(rand(2,500))

W = weight(Ω, BlockWeighter(0.1,0.1))

plot(W)
```

## Methods

```@docs
BlockWeighter
DensityRatioWeighter
```
