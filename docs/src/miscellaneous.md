# Miscellaneous

```@example misc
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats # hide
import WGLMakie as Mke # hide
```

Below is a list of miscellaneous geospatial operations.

## Split

```@docs
geosplit
```

```@example misc
using GeoStatsImages

𝒟 = geostatsimage("Strebelle")

# 50/50 split perpendicular to (1.,1.)
Π = geosplit(𝒟, 0.5, (1.0, 1.0))
```

## Integrate

```@docs
integrate(::AbstractGeoTable, ::Symbol)
```