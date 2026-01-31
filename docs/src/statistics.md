# Declustered statistics

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
```

A histogram is also available where the heights of the bins
are adjusted based on the coordinates of the samples:

```@docs
EmpiricalHistogram
```