# Clustering

Unlike traditional clustering algorithms in machine learning,
geostatistical clustering (a.k.a. domaining) algorithms consider
both the features and the geospatial coordinates of the data.

Consider the following data as an example:

```@example clustering
using GeoStats # hide
using Plots # hide
using GeoStatsPlots # hide
gr(format=:png) # hide

Ω = georef((Z=[10sin(i/10) + j for i in 1:2:100, j in 1:2:100],))

plot(Ω)
```

We can cluster the data with traditional clustering models from MLJ.jl:

```@example clustering
using MLJ

kmeans = MLJ.@load KMeans pkg=Clustering

C = cluster(Ω, kmeans(k=50))

plot(C)
```

but there is no guarantee that the clusters will consist of contiguous
volumes in space. Alternatively, we can use the following geostatistical
models:

## GHC

```@docs
GHC
```

```@example clustering
C = cluster(Ω, GHC(20, 1.0))

plot(C)
```

## GSC

```@docs
GSC
```

```@example clustering
C = cluster(Ω, GSC(50, 2.0))

plot(C)
```

## SLIC

```@docs
SLIC
```

```@example clustering
C = cluster(Ω, SLIC(50, 0.01))

plot(C)
```
