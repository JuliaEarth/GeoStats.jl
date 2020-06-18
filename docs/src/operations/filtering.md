# Filtering

## Overview

Spatial objects can be filtered:

```@docs
filter(::AbstractSpatialObject, ::AbstractFilter)
uniquecoords
```

## Example

```@example
using GeoStats # hide

Ω = PointSetData(OrderedDict(:Z=>[0, 1, 0]), [0. 1. 0.; 0. 0. 0.])

Γ = uniquecoords(Ω)

coordinates(Γ)
```

## Methods

```@docs
UniqueCoordsFilter
```
