# Miscellaneous

Below is a list of additional geospatial operations.

## Geometric

```@docs
GeoStatsBase.split(::Union{AbstractData,AbstractDomain}, ::Real)
```

```@example
using GeoStats # hide
using GeoStatsImages # hide
using Plots # hide
gr(format=:png,ms=0.2) # hide

𝒟 = geostatsimage("Strebelle")

# 50/50 split perpendicular to (1.,1.)
S = split(𝒟, 0.5, (1.,1.))

plot(plot(S[1]), plot(S[2]))
```

```@docs
uniquecoords
```

```@example
using GeoStats # hide

Ω = georef((z=[0, 1, 0],), [0. 1. 0.; 0. 0. 0.])

Γ = uniquecoords(Ω)

coordinates(Γ)
```

```@docs
boundbox
```

```@example
using GeoStats # hide

R = boundbox(RegularGrid(50, 80))

extrema(R)
```

## Tabular

```@docs
detrend!
trend
```

```@example
using GeoStats # hide
using Plots # hide

# quadratic + noise
r = range(-1,stop=1,length=100)
μ = [x^2 + y^2 for x in r, y in r]
ϵ = 0.1rand(100,100)
𝒟 = georef((z=μ+ϵ,))

ℳ = trend(𝒟, :z, degree=2)

plot(plot(𝒟), plot(ℳ))
```

```@docs
GeoStatsBase.groupby(::AbstractData, ::Symbol)
```

```@example
using GeoStats # hide
using GeoStatsImages # hide
using Plots # hide
gr(format=:png,ms=0.2) # hide

𝒟 = geostatsimage("Strebelle")

ℱ = groupby(𝒟, :facies)

plot(plot(ℱ[1]), plot(ℱ[2]))
```

```@docs
GeoStatsBase.join
```

```@example
using GeoStats # hide

Ω = georef((z=rand(100,100),))

join(Ω, Ω)
```