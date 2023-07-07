# Declustering

*Declustered statistics* are statistics that make use of geospatial
coordinates in an attempt to correct potential sampling bias:

```@raw html
<p align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/zAP-36Yh5sg" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</p>
```

The following statistics have geospatial semantics:

```@docs
mean(::Data)
var(::Data)
quantile(::Data, ::Any)
```

A histogram with geospatial semantics is also available where the heights
of the bins are adjusted based on the coordinates of the samples:

```@docs
EmpiricalHistogram
```