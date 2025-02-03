# Declustered statistics

Declustered statistics are statistics that make use of geospatial
coordinates to correct potential sampling bias:

```@raw html
<p align="center">
<iframe style="width:560px;height:315px" src="https://www.youtube.com/embed/zAP-36Yh5sg" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
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