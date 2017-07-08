![GeoStatsLogo](docs/src/images/GeoStats.png)

[![][travis-img]][travis-url] [![][julia-pkg-img]][julia-pkg-url] [![][codecov-img]][codecov-url] [![][docs-stable-img]][docs-stable-url] [![][docs-latest-img]][docs-latest-url]

High-performance implementations of geostatistical algorithms for the Julia programming language.
This package is in its initial development, and currently only contains Kriging estimation methods.
More features will be added as the Julia type system matures.

### Related packages

- [GaussianProcesses.jl](https://github.com/STOR-i/GaussianProcesses.jl) &mdash; Gaussian processes and simple Kriging are essentially [two names for the same concept](https://en.wikipedia.org/wiki/Kriging). This distinction only exists due to historical reasons. [Matheron](https://en.wikipedia.org/wiki/Georges_Matheron) and other important geostatisticians have generalized Gaussian processes to random fields with non-zero mean and for situations where the mean is unknown. Therefore, GeoStats.jl includes Gaussian processes as a special case as well as other more practical Kriging variants.

- [MLKernels.jl](https://github.com/trthatcher/MLKernels.jl) &mdash; Spatial structure can be represented in many different forms: covariance, variogram, correlogram, etc. Variograms are more general than covariance kernels according to the intrinsically stationary property. This means that there are variogram models with no covariance counterpart. Furthermore, empirical variograms can be easily estimated from the data (in various directions) with an efficient procedure. GeoStats.jl treats variograms as first-class objects.

Installation
------------

Get the latest stable release with Julia's package manager:

```julia
Pkg.add("GeoStats")
```

Documentation
-------------

- [**STABLE**][docs-stable-url] &mdash; **most recently tagged version of the documentation.**
- [**LATEST**][docs-latest-url] &mdash; *in-development version of the documentation.*

Contributing
------------

Contributions are very welcome, as are feature requests and suggestions.

Please [open an issue](https://github.com/juliohm/GeoStats.jl/issues) if you encounter any problems.

[travis-img]: https://travis-ci.org/juliohm/GeoStats.jl.svg?branch=master
[travis-url]: https://travis-ci.org/juliohm/GeoStats.jl

[julia-pkg-img]: http://pkg.julialang.org/badges/GeoStats_0.6.svg
[julia-pkg-url]: http://pkg.julialang.org/?pkg=GeoStats

[codecov-img]: https://codecov.io/gh/juliohm/GeoStats.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/juliohm/GeoStats.jl

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://juliohm.github.io/GeoStats.jl/stable

[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://juliohm.github.io/GeoStats.jl/latest
