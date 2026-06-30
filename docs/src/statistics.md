# Declustered statistics

```@example statistics
using GeoStats # hide
using GeoIO # hide
```

Declustered statistics are statistics that make use of geospatial
coordinates to correct potential sampling bias:

```@raw html
<p align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/zAP-36Yh5sg" title="Declustered Statistics" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</p>
```

We provide the following declustered statistics:

```@docs
mean(::AbstractGeoTable, ::Any)
var(::AbstractGeoTable, ::Any)
quantile(::AbstractGeoTable, ::Any, ::Any)
histogram(::AbstractGeoTable, ::Any)
```

The following example shows bias towards high `Au` values:

```@example statistics
gtb = GeoIO.load("data/clustered.csv", coords = ("x", "y"))
```

```@example statistics
mean(gtb."Au")
```

```@example statistics
mean(gtb, "Au")
```

```@example statistics
quantile(gtb."Au", 0.5)
```

```@example statistics
quantile(gtb, "Au", 0.5)
```
