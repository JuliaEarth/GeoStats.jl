# Searching

## Overview

Neighbors of a point or sample can be searched efficiently:

```@docs
search(::AbstractVector, ::AbstractNeighborSearcher)
search(::Int, ::AbstractNeighborSearcher)
```

## Example

```@example
using GeoStats # hide
using LinearAlgebra # hide
using Plots # hide
gr(format=:svg) # hide

Z = [norm([i,j]) for i in 1:100, j in 1:100]
Ω = RegularGridData(OrderedDict(:Z=>Z))

# construct searcher
b = BallNeighborhood{2}(20.)
s = NeighborhoodSearcher(Ω, b)

# query neighbors of point
inds = search([50.,50.], s)
𝒩 = view(Ω, inds)

p₁ = plot(Ω)
p₂ = plot(𝒩, lims=(0,100))

plot(p₁, p₂)
```

## Methods

```@docs
NeighborhoodSearcher
NearestNeighborSearcher
BoundedSearcher
```
