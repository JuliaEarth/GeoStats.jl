# Statistics

*Geospatial statistics* can refer to statistics computed with samples
collected in a spatial domain (a.k.a. geospatial data), or to statistics
computed with multiple realizations of a random field (a.k.a. ensemble).

## Data

The following statistics have geospatial semantics (i.e. make use of
spatial coordinates), and as such, approximate better geospatial variables
when compared to their non-geospatial counterparts:

```@docs
mean(::Data)
var(::Data)
quantile(::Data, ::Any)
```

A histogram with geospatial semantics is also available where the heights
of the bins are readjusted based on the coordinates of the samples (i.e.
declustered histogram):

```@docs
EmpiricalHistogram
```

## Ensemble

A set of geostatistical realizations of a random field represents a
probability distribution. It is often useful to compute summary
statistics with this set or ensemble:

```@docs
mean(::Ensemble)
var(::Ensemble)
quantile(::Ensemble, ::Number)
```
