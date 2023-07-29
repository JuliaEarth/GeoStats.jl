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

## Slice

```@docs
Meshes.slice
```

```@example misc
using GeoStatsImages

# slice image
I = geostatsimage("Strebelle")
S = slice(I, 50.5:100.2, 41.7:81.3)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], I.geometry, color = I.facies)
viz(fig[1,2], S.geometry, color = S.facies)
fig
```

```@example misc
# slice point set
P = sample(I, 100)
S = slice(P, 50.5:150.7, 175.2:250.3)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], P.geometry, color = P.facies)
viz(fig[1,2], S.geometry, color = S.facies)
fig
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