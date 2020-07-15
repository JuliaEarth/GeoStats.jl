# Filtering

## Overview

Spatial objects can be filtered:

```@docs
GeoStatsBase.filter
uniquecoords
```

## Example

```@example
using GeoStats # hide

Ω = georef((z=[0, 1, 0],), [0. 1. 0.; 0. 0. 0.])

Γ = uniquecoords(Ω)

coordinates(Γ)
```

## Methods

```@docs
UniqueCoordsFilter
```
