# Discretizing

## Overview

Spatial regions can be discretized:

```@docs
discretize(::AbstractRegion, ::AbstractDiscretizer)
```

## Example

```@example
using GeoStats # hide
using Plots # hide
gr(format=:svg) # hide

R = RectangleRegion((0., 0.), (100., 100.))

D = discretize(R, RegularGridDiscretizer((5, 4)))

plot(D)
```

## Methods

```@docs
RegularGridDiscretizer
```
