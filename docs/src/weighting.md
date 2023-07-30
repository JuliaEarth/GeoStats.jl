# Weighting

```@example weighting
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats # hide
import WGLMakie as Mke # hide
```

Geostatistical weighting is the process of assigning weights to geospatial
data using the geospatial coordinates of the samples. Obtained weights are
often used for declustering and importance sampling.

```@docs
weight
WeightingMethod
```

Consider the following data as an example:

```@example weighting
𝒟 = georef((Z=rand(100),), 100rand(2, 100))

viz(𝒟.geometry, color = 𝒟.Z)
```

We can weight the data with block weighting by specifing the sides of the
blocks used to count samples:

```@example weighting
𝒲 = weight(𝒟, BlockWeighting(10., 10.))
```

and then visualize the weights over the domain:

```@example weighting
viz(𝒟.geometry, color = collect(𝒲))
```

Below is the list of currently implemented weighting methods.

## UniformWeighting

```@docs
UniformWeighting
```

## BlockWeighting

```@docs
BlockWeighting
```

## DensityRatioWeighting

```@docs
DensityRatioWeighting
```
