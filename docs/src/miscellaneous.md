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
Base.split(::Any, ::Real, ::Any)
```

```@example misc
using GeoStatsImages

𝒟 = geostatsimage("Strebelle")

# 50/50 split perpendicular to (1.,1.)
Π = split(𝒟, 0.5, (1.0, 1.0))
```

## Trend

```@docs
trend
```

```@example misc
# quadratic + noise
r = range(-1,stop=1,length=100)
μ = [x^2 + y^2 for x in r, y in r]
ϵ = 0.1rand(100,100)
𝒟 = georef((Z=μ+ϵ,))

ℳ = trend(𝒟, :Z, degree=2)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], 𝒟.geometry, color = 𝒟.Z)
viz(fig[1,2], ℳ.geometry, color = ℳ.Z)
fig
```

## Integrate

```@docs
integrate(::Data, ::Symbol)
```