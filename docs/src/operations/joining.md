# Joining

## Overview

Multiple spatial objects can be joined into a single object:

```@docs
join(::AbstractSpatialObject, ::AbstractSpatialObject, ::AbstractJoiner)
```

## Example

```@example
using GeoStats # hide

Ω = RegularGridData{Float64}(OrderedDict(:Z=>rand(100,100)))

join(Ω, Ω, VariableJoiner())
```

## Methods

```@docs
VariableJoiner
```
