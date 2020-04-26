# Sampling

## Overview

Samples can be drawn from spatial objects:

```@docs
sample(::AbstractSpatialObject, ::AbstractSampler)
sample(::AbstractSpatialObject, ::Int, ::AbstractVector)
```

## Example

```@example
using GeoStats # hide
using LinearAlgebra # hide
using Plots # hide
gr(format=:svg) # hide

Z = [norm([i,j]) for i in 1:100, j in 1:100]
Ω = RegularGridData{Float64}(OrderedDict(:Z=>Z))

S = sample(Ω, 1000, replace=false)

plot(plot(Ω), plot(S))
```

## Methods

```@docs
UniformSampler
BallSampler
WeightedSampler
```
