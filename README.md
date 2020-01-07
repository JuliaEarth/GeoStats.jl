<p align="center">
  <img src="docs/src/images/GeoStats.png" height="200"><br>
  <a href="https://travis-ci.org/JuliaEarth/GeoStats.jl">
    <img src="https://travis-ci.org/JuliaEarth/GeoStats.jl.svg?branch=master">
  </a>
  <a href="https://codecov.io/gh/JuliaEarth/GeoStats.jl">
    <img src="https://codecov.io/gh/JuliaEarth/GeoStats.jl/branch/master/graph/badge.svg">
  </a>
  <a href="https://JuliaEarth.github.io/GeoStats.jl/stable">
    <img src="https://img.shields.io/badge/docs-stable-blue.svg">
  </a>
  <a href="https://JuliaEarth.github.io/GeoStats.jl/latest">
    <img src="https://img.shields.io/badge/docs-latest-blue.svg">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-ISC-blue.svg">
  </a>
  <a href="https://gitter.im/JuliaEarth/GeoStats.jl">
    <img src="https://img.shields.io/badge/chat-on%20gitter-bc0067.svg">
  </a>
</p>
<p align="center">
  Cite as &#8599;
  <a href="https://doi.org/10.21105/joss.00692">
    <img src="http://joss.theoj.org/papers/10.21105/joss.00692/status.svg">
  </a>
  <a href="https://zenodo.org/badge/latestdoi/33827844">
    <img src="https://zenodo.org/badge/33827844.svg">
  </a>
</p>

# Project goals

- Design a comprehensive framework for geostatistics (or spatial statistics) in a modern programming language.
- Address the lack of a platform for scientific comparison of different geostatistical algorithms in the literature.
- Exploit modern hardware aggressively, including GPUs and computer clusters.
- Educate people outside of the field about the existence of geostatistics.

## Installation

Get the latest stable release with Julia's package manager:

```julia
] add GeoStats
```

## Documentation

- [**STABLE**][docs-stable-url] &mdash; **most recently tagged version of the documentation.**
- [**LATEST**][docs-latest-url] &mdash; *in-development version of the documentation.*

## Tutorials

A set of Jupyter notebooks demonstrating the current functionality of the package is available
in [GeoStatsTutorials](https://github.com/JuliaEarth/GeoStatsTutorials).

Below is a quick preview of the high-level API. For the full example, please check
[this notebook](http://nbviewer.jupyter.org/github/JuliaEarth/GeoStatsTutorials/blob/master/notebooks/EstimationProblems.ipynb).

```julia
using GeoStats
using Plots

# data.csv:
#    x,    y,       station, precipitation
# 25.0, 25.0,     palo alto,           1.0
# 50.0, 75.0,  redwood city,           0.0
# 75.0, 50.0, mountain view,           1.0

# read spreadsheet file containing spatial data
sdata = readgeotable("data.csv", coordnames=[:x,:y])

# define spatial domain (e.g. regular grid, point collection)
sdomain = RegularGrid{Float64}(100, 100)

# define estimation problem for any data column(s) (e.g. :precipitation)
problem = EstimationProblem(sdata, sdomain, :precipitation)

# choose a solver from the list of solvers
solver = Kriging(
  :precipitation => (variogram=GaussianVariogram(range=35.),)
)

# solve the problem
solution = solve(problem, solver)

# plot the solution
contourf(solution, clabels=true)
```
![EstimationSolution](docs/src/images/EstimationSolution.png)

## Project organization

The project is split into various packages:

| Package  | Description |
|:--------:| ----------- |
| [GeoStats.jl](https://github.com/JuliaEarth/GeoStats.jl) | Main package reexporting full stack of packages for geostatistics. |
| [Variography.jl](https://github.com/JuliaEarth/Variography.jl) | Variogram estimation and modeling, and related tools. |
| [KrigingEstimators.jl](https://github.com/JuliaEarth/KrigingEstimators.jl) | High-performance implementations of Kriging estimators. |
| [PointPatterns.jl](https://github.com/JuliaEarth/PointPatterns.jl) | Spatial point pattern analysis and synthesis. |
| [GeoStatsImages.jl](https://github.com/JuliaEarth/GeoStatsImages.jl) | Training images for multiple-point geostatistical simulation. |
| [GslibIO.jl](https://github.com/JuliaEarth/GslibIO.jl) | Utilities to read/write *extended* GSLIB files. |
| [GeoStatsBase.jl](https://github.com/JuliaEarth/GeoStatsBase.jl) | Base package containing problem and solution specifications (for developers). |

The main package (i.e. GeoStats.jl) is self-contained, and provides the full stack of
packages for high-performance geostatistics over arbitrary domains. Other packages
like GeoStatsImages.jl can be installed from the list above for additional functionality.

### Problems and solvers

Solvers for geostatistical problems can be installed separately depending on the application.
They are automatically integrated with GeoStats.jl thanks to Julia's multiple dispatch features.

#### Estimation problems

| Solver | Description | Build | Coverage | References |
|:------:|-------------|-------|----------|------------|
| [Kriging](https://github.com/JuliaEarth/KrigingEstimators.jl) | Kriging (SK, OK, UK, EDK) | [![](https://travis-ci.org/JuliaEarth/KrigingEstimators.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/KrigingEstimators.jl) | [![](https://codecov.io/gh/JuliaEarth/KrigingEstimators.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/KrigingEstimators.jl) | [Matheron 1971](https://books.google.com/books/about/The_Theory_of_Regionalized_Variables_and.html?id=TGhGAAAAYAAJ) |
| [InvDistWeight](https://github.com/JuliaEarth/InverseDistanceWeighting.jl) | Inverse distance weighting | [![](https://travis-ci.org/JuliaEarth/InverseDistanceWeighting.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/InverseDistanceWeighting.jl) | [![](https://codecov.io/gh/JuliaEarth/InverseDistanceWeighting.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/InverseDistanceWeighting.jl) | [Shepard 1968](https://dl.acm.org/citation.cfm?id=810616) |
| [LocalWeightRegress](https://github.com/JuliaEarth/LocallyWeightedRegression.jl) | Locally weighted regression | [![](https://travis-ci.org/JuliaEarth/LocallyWeightedRegression.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/LocallyWeightedRegression.jl) | [![](https://codecov.io/gh/JuliaEarth/LocallyWeightedRegression.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/LocallyWeightedRegression.jl) | [Cleveland 1979](http://www.jstor.org/stable/2286407) |

#### Simulation problems

All simulation solvers can generate realizations in parallel unless otherwise noted.

| Solver | Description | Build | Coverage | References |
|:------:|-------------|-------|----------|------------|
| [DirectGaussSim](https://github.com/JuliaEarth/DirectGaussianSimulation.jl) | Direct Gaussian simulation | [![](https://travis-ci.org/JuliaEarth/DirectGaussianSimulation.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/DirectGaussianSimulation.jl) | [![](https://codecov.io/gh/JuliaEarth/DirectGaussianSimulation.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/DirectGaussianSimulation.jl) | [Alabert 1987](https://link.springer.com/article/10.1007/BF00897191) |
| [SeqGaussSim](https://github.com/JuliaEarth/KrigingEstimators.jl) | Sequential Gaussian simulation | [![](https://travis-ci.org/JuliaEarth/KrigingEstimators.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/KrigingEstimators.jl) | [![](https://codecov.io/gh/JuliaEarth/KrigingEstimators.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/KrigingEstimators.jl) | [Gómez-Hernández 1993](https://link.springer.com/chapter/10.1007/978-94-011-1739-5_8) |
| [SpecGaussSim](https://github.com/JuliaEarth/SpectralGaussianSimulation.jl) | Spectral Gaussian simulation | [![](https://travis-ci.org/JuliaEarth/SpectralGaussianSimulation.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/SpectralGaussianSimulation.jl) | [![](https://codecov.io/gh/JuliaEarth/SpectralGaussianSimulation.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/SpectralGaussianSimulation.jl) | [Gutjahr 1997](https://link.springer.com/article/10.1007/BF02769641) |
| [TuringPat](https://github.com/yurivish/TuringPatterns.jl) | Turing patterns | [![](https://travis-ci.org/yurivish/TuringPatterns.jl.svg?branch=master)](https://travis-ci.org/yurivish/TuringPatterns.jl) | [![](https://codecov.io/gh/yurivish/TuringPatterns.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/yurivish/TuringPatterns.jl) | [Turing 1952](https://royalsocietypublishing.org/doi/pdf/10.1098/rstb.1952.0012) |
| [ImgQuilt](https://github.com/JuliaEarth/ImageQuilting.jl) | Fast image quilting | [![](https://travis-ci.org/JuliaEarth/ImageQuilting.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/ImageQuilting.jl) | [![](https://codecov.io/gh/JuliaEarth/ImageQuilting.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/ImageQuilting.jl) | [Hoffimann 2017](http://www.sciencedirect.com/science/article/pii/S0098300417301139) |
| [StratSim](https://github.com/JuliaEarth/StratiGraphics.jl) | Stratigraphy simulation | [![](https://travis-ci.org/JuliaEarth/StratiGraphics.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/StratiGraphics.jl) | [![](https://codecov.io/gh/JuliaEarth/StratiGraphics.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/StratiGraphics.jl) | [Hoffimann 2018](https://searchworks.stanford.edu/view/12746435) |
| [CookieCutter](https://github.com/JuliaEarth/GeoStatsBase.jl) | Cookie-cutter scheme | [![](https://travis-ci.org/JuliaEarth/GeoStatsBase.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/GeoStatsBase.jl) | [![](https://codecov.io/gh/JuliaEarth/GeoStatsBase.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/GeoStatsBase.jl) | [Begg 1992](https://www.onepetro.org/conference-paper/SPE-24698-MS) |

#### Learning problems

| Solver | Description | Build | Coverage | References |
|:------:|-------------|-------|----------|------------|
| [PointwiseLearn](https://github.com/JuliaEarth/GeoStatsBase.jl) | Pointwise learning | [![](https://travis-ci.org/JuliaEarth/GeoStatsBase.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/GeoStatsBase.jl) | [![](https://codecov.io/gh/JuliaEarth/GeoStatsBase.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/GeoStatsBase.jl) | [Hoffimann 2018](https://doi.org/10.21105/joss.00692) |

If you are a developer and your solver is not listed above, please open a pull request and
we will be happy to review and add it to the list. Please check the developer guide in the
documentation below for instructions on how to write your own solvers.

## Contributing and supporting

Contributions are very welcome, as are feature requests and suggestions. Please
[open an issue](https://github.com/JuliaEarth/GeoStats.jl/issues) if you encounter
any problems. We have [written instructions](CONTRIBUTING.md) to help you with
the process.

If you have questions, don't hesitate to ask. Join our community in our
[gitter channel](https://gitter.im/JuliaEarth/GeoStats.jl). We are always
willing to help.

GeoStats.jl was developed as part of academic research. It will always be open
source and free of charge. If you would like to help support the project, please
star the repository and share it with your colleagues.

## Citation

If you find GeoStats.jl useful in your work, please consider citing it:

[![JOSS][joss-img]][joss-url]
[![DOI][zenodo-img]][zenodo-url]

```latex
@ARTICLE{GeoStats.jl-2018,
  title={GeoStats.jl – High-performance geostatistics in Julia},
  author={Hoffimann, Júlio},
  journal={Journal of Open Source Software},
  publisher={The Open Journal},
  volume={3},
  pages={692},
  number={24},
  ISSN={2475-9066},
  DOI={10.21105/joss.00692},
  url={http://dx.doi.org/10.21105/joss.00692},
  year={2018},
  month={Apr}
}
```

## Used at

<p align="center">
  <img src="docs/src/images/Stanford.png" height="100">
  <img src="docs/src/images/IBM.png" height="100"><br><br>
  <img src="docs/src/images/Deltares.png" height="150" hspace="20">
  <img src="docs/src/images/ENI.png" height="150" hspace="20">
</p>

[travis-img]: https://travis-ci.org/JuliaEarth/GeoStats.jl.svg?branch=master
[travis-url]: https://travis-ci.org/JuliaEarth/GeoStats.jl

[julia-pkg-img]: http://pkg.julialang.org/badges/GeoStats_0.7.svg
[julia-pkg-url]: http://pkg.julialang.org/?pkg=GeoStats

[codecov-img]: https://codecov.io/gh/JuliaEarth/GeoStats.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/JuliaEarth/GeoStats.jl

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://JuliaEarth.github.io/GeoStats.jl/stable

[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://JuliaEarth.github.io/GeoStats.jl/latest

[license-img]: https://img.shields.io/badge/license-ISC-blue.svg
[license-url]: LICENSE

[gitter-img]: https://img.shields.io/badge/chat-on%20gitter-bc0067.svg
[gitter-url]: https://gitter.im/JuliaEarth/GeoStats.jl

[joss-img]: http://joss.theoj.org/papers/10.21105/joss.00692/status.svg
[joss-url]: https://doi.org/10.21105/joss.00692

[zenodo-img]: https://zenodo.org/badge/33827844.svg
[zenodo-url]: https://zenodo.org/badge/latestdoi/33827844
