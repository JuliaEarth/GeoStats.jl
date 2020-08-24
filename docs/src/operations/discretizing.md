# Discretizing

## Overview

Geometries can be discretized:

```@docs
discretize
```

## Example

```@example
using GeoStats # hide
using Plots # hide
gr(format=:svg) # hide

R = Rectangle((0., 0.), (100., 100.))

D = discretize(R, RegularGridDiscretizer((5, 4)))

plot(D)
```

## Methods

```@docs
RegularGridDiscretizer
```
