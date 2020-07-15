# Sampling

## Overview

Samples can be drawn from spatial objects:

```@docs
GeoStatsBase.sample
```

## Example

```@example
using GeoStats # hide
using LinearAlgebra # hide
using Plots # hide
gr(format=:svg) # hide


Ω = georef((Z=[norm([i,j]) for i in 1:100, j in 1:100],))

S = sample(Ω, 1000, replace=false)

plot(plot(Ω), plot(S))
```

## Methods

```@docs
UniformSampler
BallSampler
WeightedSampler
```
