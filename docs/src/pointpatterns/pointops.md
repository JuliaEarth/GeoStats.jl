# Operations

```@example pointops
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats, GeoStatsViz # hide
import WGLMakie as Mke # hide
```

Below is the list of currently implemented operations for point
processes and patterns.

## Superposition

The union or (superposition) of two point processes creates a
union process:

```@docs
Base.union(::PointProcess, ::PointProcess)
```

## Thinning

The [`thin`](@ref) function implements the thinning operation for
point processes and patterns. Below are the available thinning
methods.

```@docs
thin
RandomThinning
```
