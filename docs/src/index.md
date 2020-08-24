# GeoStats.jl

*An extensible framework for high-performance geostatistics in Julia.*

[![Build Status](https://img.shields.io/travis/JuliaEarth/GeoStats.jl?style=flat-square)](https://travis-ci.org/JuliaEarth/GeoStats.jl)
[![Coverage Status](https://img.shields.io/codecov/c/github/JuliaEarth/GeoStats.jl?style=flat-square)](https://codecov.io/gh/JuliaEarth/GeoStats.jl)
[![Stable Documentation](https://img.shields.io/badge/docs-stable-blue?style=flat-square)](https://JuliaEarth.github.io/GeoStats.jl/stable)
[![Latest Documentation](https://img.shields.io/badge/docs-latest-blue?style=flat-square)](https://JuliaEarth.github.io/GeoStats.jl/latest)
[![License File](https://img.shields.io/badge/license-ISC-blue?style=flat-square)](https://github.com/JuliaEarth/GeoStats.jl/blob/master/LICENSE)

[![Gitter](https://img.shields.io/badge/chat-on%20gitter-bc0067?style=flat-square)](https://gitter.im/JuliaEarth/GeoStats.jl)
[![JOSS](https://img.shields.io/badge/JOSS-10.21105%2Fjoss.00692-brightgreen?style=flat-square)](https://doi.org/10.21105/joss.00692)
[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.3875233-blue?style=flat-square)](https://zenodo.org/badge/latestdoi/33827844)

## Overview

In many fields of science, such as mining engineering, hydrogeology, petroleum
engineering, and environmental sciences, traditional statistical theories fail
to provide unbiased estimates of resources due to the presence of spatial
correlation. Geostatistics (a.k.a. spatial statistics) is the branch of
statistics developed to overcome this limitation. Particularly, it is the
branch that takes spatial coordinates of data into account.

[GeoStats.jl](https://github.com/JuliaEarth/GeoStats.jl) is an attempt to bring
together bleeding-edge research in the geostatistics community into a comprehensive
framework for spatial statistics, as well as to empower researchers and practioners
with a toolkit for fast assessment of different modeling approaches.

The design of this project is the result of many years developing geostatistical
software. I hope that it can serve to promote more collaboration between
geostatisticians around the globe and to standardize this incredible science.
If you would like to help support the project, please
star the repository [![STARS](https://img.shields.io/github/stars/JuliaEarth/GeoStats.jl?style=social)]
(https://github.com/JuliaEarth/GeoStats.jl) and share it with your colleagues.
If you would like to extend the framework with new geostatistical solvers,
please check the [Developer guide](contributing/solvers.md).

### Citing

```latex
@ARTICLE{Hoffimann2018,
  title={GeoStats.jl – High-performance geostatistics in Julia},
  author={Hoffimann, Júlio},
  journal={Journal of Open Source Software},
  publisher={The Open Journal},
  volume={3},
  pages={692},
  number={24},
  ISSN={2475-9066},
  DOI={10.21105/joss.00692},
  url={https://dx.doi.org/10.21105/joss.00692},
  year={2018},
  month={Apr}
}
```

## Installation

Get the latest stable release with Julia's package manager:

```julia
] add GeoStats
```

## Tutorials

A set of Jupyter notebooks demonstrating the current functionality of the project
is available in [GeoStatsTutorials](https://github.com/JuliaEarth/GeoStatsTutorials)
with an accompanying series of videos:

```@raw html
<p align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/yDIK9onnZVw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</p>
```

## Quick example

Below is a quick preview of the high-level API:

```@example overview
using GeoStats
using Plots
gr(size=(900,400)) # hide

# list of properties with coordinates
props = (Z=[1.,0.,1.],)
coord = [25. 50. 75.
         25. 75. 50.]

# georeference data
𝒟 = georef(props, coord)

# estimation domain
𝒢 = RegularGrid(100, 100)

# estimation problem
problem = EstimationProblem(𝒟, 𝒢, :Z)

# choose a solver from the list of solvers
solver = Kriging(
  :Z => (variogram=GaussianVariogram(range=35.),)
)

# solve the problem
solution = solve(problem, solver)

# plot the solution
contourf(solution, clabels=true)
```

For a more elaborated example, please consult the [Basic workflow](workflow.md)
section of the documentation.

## Project organization

The project is split into various packages:

| Package | Description |
|:-------:|:------------|
| [GeoStats.jl](https://github.com/JuliaEarth/GeoStats.jl) | Main package reexporting full stack of packages for geostatistics. |
| [Variography.jl](https://github.com/JuliaEarth/Variography.jl) | Variogram estimation and modeling, and related tools. |
| [KrigingEstimators.jl](https://github.com/JuliaEarth/KrigingEstimators.jl) | High-performance implementations of Kriging estimators. |
| [PointPatterns.jl](https://github.com/JuliaEarth/PointPatterns.jl) | Spatial point pattern analysis and synthesis. |
| [GeoStatsImages.jl](https://github.com/JuliaEarth/GeoStatsImages.jl) | Training images for multiple-point geostatistical simulation. |
| [GslibIO.jl](https://github.com/JuliaEarth/GslibIO.jl) | Utilities to read/write *extended* GSLIB files. |
| [GeoStatsBase.jl](https://github.com/JuliaEarth/GeoStatsBase.jl) | Base package containing interfaces and developer tools. |

The main [GeoStats.jl](https://github.com/JuliaEarth/GeoStats.jl) package reexports
the full stack of packages for high-performance geostatistics in Julia. Other
packages like [GeoStatsImages.jl](https://github.com/JuliaEarth/GeoStatsImages.jl)
can be installed for additional functionality. Besides the packages above, the
project is extended via [solver packages](solvers.md). These solvers are implemented
independently of the main package for different geostatistical problems.
