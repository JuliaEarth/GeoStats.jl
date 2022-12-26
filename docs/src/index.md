# GeoStats.jl

*An extensible framework for high-performance geostatistics in Julia.*

```@raw html
<p align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/75A6zyn5pIE" title="Geostatistical Learning" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</p>
```

## Overview

In many fields of science, such as mining engineering, hydrogeology, petroleum
engineering, and environmental sciences, traditional statistical methods fail
to provide unbiased estimates of resources due to the presence of geospatial
correlation. Geostatistics (a.k.a. geospatial statistics) is the branch of
statistics developed to overcome this limitation. Particularly, it is the
branch that takes geospatial coordinates of data into account.

[GeoStats.jl](https://github.com/JuliaEarth/GeoStats.jl) is an attempt to bring
together bleeding-edge research in the geostatistics community into a comprehensive
framework for geospatial modeling, as well as to empower researchers and practioners
with a toolkit for fast assessment of different modeling approaches.

The design of this project is the result of many years developing geostatistical
software. I hope that it can serve to promote more collaboration between
geostatisticians around the globe and to standardize this incredible field of
research. If you would like to help support the project, please star the repository
[![STARS](https://img.shields.io/github/stars/JuliaEarth/GeoStats.jl?style=social)]
(https://github.com/JuliaEarth/GeoStats.jl) and share it with your colleagues.
If you would like to extend the framework with new geostatistical solvers,
please check the [Developer guide](contributing/solvers.md).

### Citing

If you find this project useful in your work, please consider citing it: 

[![JOSS](https://img.shields.io/badge/JOSS-10.21105%2Fjoss.00692-brightgreen?style=flat-square)](https://doi.org/10.21105/joss.00692)
[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.3875233-blue?style=flat-square)](https://zenodo.org/badge/latestdoi/33827844)

```bibtex
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

We ❤ to see our [list of publications](resources/publications.md) growing.

## Installation

Get the latest stable release with Julia's package manager:

```
] add GeoStats
```

## Tutorials

A set of Pluto notebooks demonstrating the current functionality of the project
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
using Plots, GeoStatsPlots
gr(size=(900,400)) # hide

# attribute table
table = (Z=[1.,0.,1.],)

# coordinates for each row
coord = [(25.,25.), (50.,75.), (75.,50.)]

# georeference data
𝒟 = georef(table, coord)

# estimation domain
𝒢 = CartesianGrid(100, 100)

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

For a more detailed example, please consult the [Quickstart](quickstart.md).

## Project organization

The project is split into various packages:

| Package | Description |
|:-------:|:------------|
| [GeoStats.jl](https://github.com/JuliaEarth/GeoStats.jl) | Main package reexporting full stack of packages for geostatistics. |
| [Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl) | Computational geometry and advanced meshing algorithms. |
| [Variography.jl](https://github.com/JuliaEarth/Variography.jl) | Variogram estimation and modeling, and related tools. |
| [KrigingEstimators.jl](https://github.com/JuliaEarth/KrigingEstimators.jl) | High-performance implementations of Kriging estimators. |
| [PointPatterns.jl](https://github.com/JuliaEarth/PointPatterns.jl) | Geospatial point pattern analysis and synthesis. |
| [GeoClustering.jl](https://github.com/JuliaEarth/GeoClustering.jl) | Geostatistical clustering (a.k.a. domaining). |
| [GeoStatsSolvers.jl](https://github.com/JuliaEarth/GeoStatsSolvers.jl) | Built-in geostatistical solvers. |
| [GeoStatsBase.jl](https://github.com/JuliaEarth/GeoStatsBase.jl) | Base package with core definitions. |

Other packages can be installed separately for additional functionality:

| Package | Description |
|:-------:|:------------|
| [GeoStatsImages.jl](https://github.com/JuliaEarth/GeoStatsImages.jl) | Training images for multiple-point simulation. |
| [GeoTables.jl](https://github.com/JuliaEarth/GeoTables.jl) | (Down)load geospatial tables in various formats. |
| [DrillHoles.jl](https://github.com/JuliaEarth/DrillHoles.jl) | Desurvey/composite drillhole data. |
| [GslibIO.jl](https://github.com/JuliaEarth/GslibIO.jl) | Load/save (extended) GSLIB files. |

Besides the packages above, the project can be extended with [solver packages](solvers/overview.md).

## Community channels

We invite you to join our [community channels](about/community.md).
There you will meet other fellow geostatisticians who like to code.
We are very friendly, come say hi! 😄🌎