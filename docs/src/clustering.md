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

## Geostatistical

Unlike classical clustering methods in machine learning,
geostatistical clustering (a.k.a. domaining) methods consider
both the [`values`](@ref) and the [`domain`](@ref) of the data.

```@docs
GHC
```

```@example clustering
ctb = gtb |> GHC(20, 1.0)

ctb |> viewer
```

```@docs
GSC
```

```@example clustering
ctb = gtb |> GSC(50, 2.0)

ctb |> viewer
```

```@docs
SLIC
```

```@example clustering
ctb = gtb |> SLIC(50, 0.01)

ctb |> viewer
```
