![GeoStatsLogo](docs/src/images/GeoStats.png)

[![][travis-img]][travis-url] [![][julia-pkg-img]][julia-pkg-url] [![][codecov-img]][codecov-url] [![][docs-stable-img]][docs-stable-url] [![][docs-latest-img]][docs-latest-url]

High-performance implementations of geostatistical algorithms for the Julia programming language.
This package is in its initial development, and currently only contains Kriging estimation methods.
More features will be added as the Julia type system matures.

# Project goals

- Design a comprehensive framework for geostatistics (or spatial statistics) in a modern programming language.
- Address the lack of a platform for scientific comparison of different geostatistical algorithms in the literature.
- Exploit modern hardware aggressively, including GPUs and computer clusters.
- Educate people outside of the field about the existence of geostatistics.

### Related packages

- [GaussianProcesses.jl](https://github.com/STOR-i/GaussianProcesses.jl) &mdash; Gaussian processes
and Simple Kriging are essentially [two names for the same concept](https://en.wikipedia.org/wiki/Kriging),
and this distinction only exists due to historical reasons. [Matheron](https://en.wikipedia.org/wiki/Georges_Matheron)
and other important geostatisticians have generalized Gaussian processes to random fields with non-zero mean and
for situations where the mean is unknown. GeoStats.jl includes Gaussian processes as a special case as
well as other more practical Kriging variants, see the [Gaussian processes example](examples).

- [MLKernels.jl](https://github.com/trthatcher/MLKernels.jl) &mdash; Spatial structure can be
represented in many different forms: covariance, variogram, correlogram, etc. Variograms are more
general than covariance kernels according to the intrinsically stationary property. This means that
there are variogram models with no covariance counterpart. Furthermore, empirical variograms can be
easily estimated from the data (in various directions) with an efficient procedure. GeoStats.jl treats
variograms as first-class objects, see the [Variogram modeling example](examples).

- [celerite.jl](https://github.com/ericagol/celerite.jl) &mdash; For 1D Gaussian processes, this project
was originally written in C++/Python and is now ported to Julia.

- [Interpolations.jl](https://github.com/JuliaMath/Interpolations.jl) &mdash; Kriging and Spline interpolation
have different purposes, yet these two methods are sometimes listed as competing alternatives. Kriging estimation
is about minimizing variance (or estimation error), whereas Spline interpolation is about forcedly smooth estimators
derived for *computer visualization*. [Kriging is a generalization of Splines](http://www.sciencedirect.com/science/article/pii/009830048490030X)
in which one has the freedom to customize spatial structure based on data. Besides the estimate itself, Kriging
also provides the variance map as a function of knots configuration.

Installation
------------

Get the latest stable release with Julia's package manager:

```julia
Pkg.add("GeoStats")
```

Project organization
--------------------

The project is split into various packages:

| Package           | Description |
|:-----------------:| ----------- |
| [GeoStats.jl](https://github.com/juliohm/GeoStats.jl) | Main package containing problem definitions, Kriging-based solvers, and other geostatistical tools. |
| [GeoStatsImages.jl](https://github.com/juliohm/GeoStatsImages.jl) | Training images for multiple-point geostatistical simulation. |
| [GslibIO.jl](https://github.com/juliohm/GslibIO.jl) | Utilities to read/write *extended* GSLIB files. |

The main package (i.e. GeoStats.jl) is self-contained, and provides high-performance Kriging-based estimation/simulation algorithms over arbitrary domains. Other packages can be installed from the list above for additional functionality.

Documentation
-------------

- [**STABLE**][docs-stable-url] &mdash; **most recently tagged version of the documentation.**
- [**LATEST**][docs-latest-url] &mdash; *in-development version of the documentation.*

Examples
--------

A set of Jupyter notebooks demonstrating the current functionality of the package is available
in the [examples](examples) folder. These notebooks are distributed with GeoStats.jl and can be
launched locally with `GeoStats.examples()`.

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
