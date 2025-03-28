# Clustering

```@example clustering
using GeoStats # hide
import CairoMakie as Mke # hide
```

## Overview

We provide various geostatistical clustering methods to divide geospatial
data into regions with homogeneous features. These methods can consider
the [`values`](@ref) of the geotable (the *classical* approach), or both the
[`values`](@ref) and the [`domain`](@ref) (the *geostatistical* approach).

Consider the following geotable for illustration purposes:

```@example clustering
gtb = georef((z=[10sin(i/10) + j for i in 1:4:100, j in 1:4:100],))

gtb |> viewer
```

## Classical

```@docs
KMedoids
```

```@example clustering
ctb = gtb |> KMedoids(5)

ctb |> viewer
```

## Geostatistical

```@docs
GHC
```

```@example clustering
ctb = gtb |> GHC(5, 1.0)

ctb |> viewer
```

```@docs
GSC
```

```@example clustering
ctb = gtb |> GSC(5, 2.0)

ctb |> viewer
```

```@docs
SLIC
```

```@example clustering
ctb = gtb |> SLIC(5, 0.01)

ctb |> viewer
```
