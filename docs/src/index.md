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

Geostatistics (a.k.a. spatial statistics) is the branch of statistics that deals with
spatial data. In many fields of science, such as mining engineering, hydrogeology,
petroleum engineering, and environmental sciences, traditional regression techniques
fail to capture spatiotemporal correlation, and therefore are not satisfactory tools
for decision making involving spatial resources.

GeoStats.jl is an attempt to bring together bleeding-edge research in the geostatistics
community into a comprehensive framework, and to empower researchers and practioners
with a toolkit for fast assessment of different modeling approaches.

The design of this package is the result of many years developing geostatistical software.
I hope that it can serve to promote more collaboration between geostatisticians around the
globe and to standardize this incredible science.

If you would like to help support the project, please
[star the repository on GitHub](https://github.com/juliohm/GeoStats.jl)
and share it with your colleagues. If you are a developer,
please check the [Developer guide](developer_basics.md).

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
| [GeoStatsDevTools.jl](https://github.com/juliohm/GeoStatsDevTools.jl) | Developer tools for writing new solvers (for developers). |

The main package (i.e. GeoStats.jl) is self-contained, and provides high-performance
Kriging-based estimation/simulation algorithms over arbitrary domains. Other packages
can be installed from the list above for additional functionality.

## Quick example

Below is a quick preview of the high-level API. For the full example, please see
the [GeoStatsTutorials](https://github.com/juliohm/GeoStatsTutorials) repository.

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
contourf(solution, contour_labels=true)
png("images/EstimationSolution.png") # hide
```
![](images/EstimationSolution.png)

### Low-level API

If you are interested in finer control, some estimators
can also be used directly:

```@example
using GeoStats
using Random, Statistics # hide
Random.seed!(2017) # hide

# create some data
dim, nobs = 3, 10
X = rand(dim, nobs)
z = rand(nobs)

# target location
xₒ = rand(dim)

# define a variogram model
γ = GaussianVariogram(sill=1., range=1., nugget=0.)

# define an estimator (i.e. build the Kriging system)
sk = SimpleKriging(X, z, γ, mean(z))
ok = OrdinaryKriging(X, z, γ)
uk = UniversalKriging(X, z, γ, 0)

# estimate at target location
μ, σ² = predict(sk, xₒ)
println("Simple Kriging:") # hide
println("  μ = $μ, σ² = $σ²") # hide
μ, σ² = predict(ok, xₒ)
println("Ordinary Kriging:") # hide
println("  μ = $μ, σ² = $σ²") # hide
μ, σ² = predict(uk, xₒ)
println("Universal Kriging:") # hide
println("  μ = $μ, σ² = $σ²") # hide
```
