# Clustering

Geostatistical clustering (a.k.a. domaining) is the process of partitioning
geospatial data in terms of both features and geospatial coordinates. Below
is the current list of clustering methods available:

## SLIC

```@docs
SLIC
```

```@example clustering
using GeoStats # hide
using Plots # hide
using GeoStatsPlots # hide
gr(format=:png) # hide

Ω = georef((Z=[10sin(i/10) + j for i in 1:100, j in 1:100],))

C = cluster(Ω, SLIC(50, 0.01))

plot(plot(Ω), plot(C))
```

## GHC

```@docs
GHC
```

```@example clustering
C = cluster(Ω, GHC(20, 1.0))

plot(plot(Ω), plot(C))
```

## GSC

```@docs
GSC
```

```@example clustering
C = cluster(Ω, GSC(50, 2.0))

plot(plot(Ω), plot(C))
```
