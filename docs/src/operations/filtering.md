# Filtering

## Overview

Spatial objects can be filtered:

```@docs
filter(::AbstractSpatialObject, ::AbstractFilter)
```

## Example

```@example
using GeoStats # hide

Ω = PointSetData(OrderedDict(:Z=>[0, 1, 0]), [0. 1. 0.; 0. 0. 0.])

Γ = filter(Ω, UniqueCoordsFilter())

coordinates(Γ)
```

## Methods

```@docs
UniqueCoordsFilter
```
