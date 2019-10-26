![GeoStatsLogo](images/GeoStats.png)

[![Build Status](https://travis-ci.org/juliohm/GeoStats.jl.svg?branch=master)](https://travis-ci.org/juliohm/GeoStats.jl)
[![Coverage Status](https://codecov.io/gh/juliohm/GeoStats.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/juliohm/GeoStats.jl)
[![Stable Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliohm.github.io/GeoStats.jl/stable)
[![Latest Documentation](https://img.shields.io/badge/docs-latest-blue.svg)](https://juliohm.github.io/GeoStats.jl/latest)
[![License File](https://img.shields.io/badge/license-ISC-blue.svg)](https://github.com/juliohm/GeoStats.jl/blob/master/LICENSE)
[![Gitter](https://img.shields.io/badge/chat-on%20gitter-bc0067.svg)](https://gitter.im/JuliaEarth/GeoStats.jl)
[![JOSS](http://joss.theoj.org/papers/10.21105/joss.00692/status.svg)](https://doi.org/10.21105/joss.00692)
[![DOI](https://zenodo.org/badge/33827844.svg)](https://zenodo.org/badge/latestdoi/33827844)

## Overview

In many fields of science, such as mining engineering, hydrogeology, petroleum engineering,
and environmental sciences, traditional statistical theories fail to provide unbiased estimates
of resources due to the presence of spatial correlation. Geostatistics (a.k.a. spatial statistics)
is the branch of statistics developed to overcome this limitation. Particularly, it is the branch
that takes spatial coordinates of data into account.

GeoStats.jl is an attempt to bring together bleeding-edge research in the geostatistics community
into a comprehensive framework for spatial statistics, as well as to empower researchers and
practioners with a toolkit for fast assessment of different modeling approaches. The framework is
well-integrated with the Julia ecosystem, including the [MLJ.jl](https://github.com/alan-turing-institute/MLJ.jl)
and [Plots.jl](https://github.com/JuliaPlots/Plots.jl) projects for learning and plotting spatial variables.

The design of this project is the result of many years developing geostatistical software. I hope that
it can serve to promote more collaboration between geostatisticians around the globe and to
standardize this incredible science. If you would like to help support the project, please
[star the repository on GitHub](https://github.com/juliohm/GeoStats.jl) and share it with your
colleagues. If you are a developer, please check the [Developer guide](devguide.md).

## Installation

Get the latest stable release with Julia's package manager:

```julia
] add GeoStats
```

## Project organization

The project is split into various packages:

| Package  | Description |
|:--------:| ----------- |
| [GeoStats.jl](https://github.com/juliohm/GeoStats.jl) | Main package containing Kriging-based solvers, and other geostatistical tools. |
| [GeoStatsImages.jl](https://github.com/juliohm/GeoStatsImages.jl) | Training images for multiple-point geostatistical simulation. |
| [GslibIO.jl](https://github.com/juliohm/GslibIO.jl) | Utilities to read/write *extended* GSLIB files. |
| [Variography.jl](https://github.com/juliohm/Variography.jl) | Variogram estimation and modeling, and related tools. |
| [KrigingEstimators.jl](https://github.com/juliohm/KrigingEstimators.jl) | High-performance implementations of Kriging estimators. |
| [GeoStatsBase.jl](https://github.com/juliohm/GeoStatsBase.jl) | Base package containing problem and solution specifications (for developers). |

The main package (i.e. GeoStats.jl) is self-contained, and provides high-performance
Kriging-based estimation/simulation algorithms over arbitrary domains. Other packages
can be installed from the list above for additional functionality.

Besides the packages above, the project is extended via solver packages, for which
the links are listed in the [README](https://github.com/juliohm/GeoStats.jl) on GitHub.
These solvers are implemented independently of the main package for different
geostatistical problems.

## Quick example

Below is a quick preview of a geostatistical estimation problem solved with a Kriging
solver. Besides estimation, the framework implements various solvers for
geostatistical simulation and geostatitistical learning problems.

```@example overview
using GeoStats
using Plots
gr(size=(900,400)) # hide

# define spatial data
sdata = PointSetData(Dict(:precipitation => [1.,0.,1.]), [(25.,25.),(50.,75.),(75.,50.)])

# define spatial domain (e.g. regular grid, point set)
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
png("images/EstimationSolution.png") # hide
```
![](images/EstimationSolution.png)

For the full example, please see the [Tutorials](tutorials.md) section of the documentation.
