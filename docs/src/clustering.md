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

We can cluster the data with traditional clustering models from
[MLJ.jl](https://github.com/alan-turing-institute/MLJ.jl):

```@example clustering
using MLJ

kmeans = MLJ.@load KMeans pkg=Clustering

𝒞 = cluster(Ω, kmeans(k=50))

viz(𝒞.geometry, color = 𝒞.cluster)
```

but there is no guarantee that the clusters will consist of contiguous
volumes in space. Alternatively, we can use the following geostatistical
models:

## GHC

```@docs
GHC
```

```@example clustering
𝒞 = cluster(Ω, GHC(20, 1.0))

viz(𝒞.geometry, color = 𝒞.cluster)
```

## GSC

```@docs
GSC
```

```@example clustering
𝒞 = cluster(Ω, GSC(50, 2.0))

viz(𝒞.geometry, color = 𝒞.cluster)
```

## SLIC

```@docs
SLIC
```

```@example clustering
𝒞 = cluster(Ω, SLIC(50, 0.01))

viz(𝒞.geometry, color = 𝒞.cluster)
```
