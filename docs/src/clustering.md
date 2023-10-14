# Clustering

```@example clustering
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats # hide
import WGLMakie as Mke # hide
```

Unlike traditional clustering algorithms in machine learning,
geostatistical clustering (a.k.a. domaining) algorithms consider
both the features and the geospatial coordinates of the data.

Consider the following data as an example:

```@example clustering
Ω = georef((Z=[10sin(i/10) + j for i in 1:4:100, j in 1:4:100],))

viz(Ω.geometry, color = Ω.Z)
```

## GHC

```@docs
GHC
```

```@example clustering
𝒞 = Ω |> GHC(20, 1.0)

viz(𝒞.geometry, color = 𝒞.CLUSTER)
```

## GSC

```@docs
GSC
```

```@example clustering
𝒞 = Ω |> GSC(50, 2.0)

viz(𝒞.geometry, color = 𝒞.CLUSTER)
```

## SLIC

```@docs
SLIC
```

```@example clustering
𝒞 = Ω |> SLIC(50, 0.01)

viz(𝒞.geometry, color = 𝒞.CLUSTER)
```
