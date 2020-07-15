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

Ω = georef((Z=[norm([i,j]) for i in 1:100, j in 1:100],))
S = sample(Ω, 1000, replace=false)

W = weight(S, BlockWeighter(10.,10.))

plot(plot(S), plot(W))
```

## Methods

```@docs
BlockWeighter
DensityRatioWeighter
```
