# Miscellaneous

Below is a list of miscellaneous geospatial operations.

## Split

```@example
using GeoStats
using GeoStatsImages
using Plots # hide
using GeoStatsPlots # hide
gr(format=:png) # hide

𝒟 = geostatsimage("Strebelle")

# 50/50 split perpendicular to (1.,1.)
S = split(𝒟, 0.5, (1.,1.))

plot(plot(S[1],ms=0.2), plot(S[2],ms=0.2))
```

## Slice

```@docs
Meshes.slice
```

```@example
using GeoStats # hide
using GeoStatsImages # hide
using Plots # hide
using GeoStatsPlots # hide
gr(format=:png) # hide

# slice image
I = geostatsimage("Strebelle")
S = slice(I, 50.5:100.2, 41.7:81.3)

p1 = plot(plot(I), plot(S), link=:both)

# slide point set
P = sample(I, 100)
S = slice(P, 50.5:150.7, 175.2:250.3)

p2 = plot(plot(P), plot(S), link=:both, ms=3)

plot(p1, p2, layout=(2,1))
```

## Unique

```@docs
uniquecoords
```

```@example
using GeoStats # hide
using Tables # hide

D = georef((z=[0, 1, 0],), [(0.,0.), (1.,0.), (0.,0.)])

U = uniquecoords(D)

Tables.rows(U)
```

## Trend

```@docs
trend
```

```@example
using GeoStats # hide
using Plots # hide
using GeoStatsPlots # hide

# quadratic + noise
r = range(-1,stop=1,length=100)
μ = [x^2 + y^2 for x in r, y in r]
ϵ = 0.1rand(100,100)
𝒟 = georef((z=μ+ϵ,))

ℳ = trend(𝒟, :z, degree=2)

plot(plot(𝒟), plot(ℳ))
```

## Integrate

```@docs
integrate(::Data, ::Symbol)
```