# Searching

## Overview

Neighbors of a point or sample can be searched efficiently:

```
Meshes.search
```

## Example

```@example
using GeoStats # hide
using LinearAlgebra # hide
using Plots # hide
gr(format=:svg) # hide

Ω = georef((Z=[norm([i,j]) for i in 1:100, j in 1:100],))

# construct searcher
b = NormBall(20.)
s = NeighborhoodSearch(Ω, b)

# query neighbors of point
inds = search(Point(50.,50.), s)
𝒩 = view(Ω, inds)

p₁ = plot(Ω)
p₂ = plot(𝒩, lims=(0,100))

plot(p₁, p₂)
```

## Methods

```@docs
NeighborhoodSearch
KNearestSearch
KBallSearch
BoundedSearch
```
