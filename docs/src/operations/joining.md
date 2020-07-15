# Joining

## Overview

Multiple spatial objects can be joined into a single object:

```@docs
GeoStatsBase.join
```

## Example

```@example
using GeoStats # hide

Ω = georef((z=rand(100,100),))

join(Ω, Ω, VariableJoiner())
```

## Methods

```@docs
VariableJoiner
```
