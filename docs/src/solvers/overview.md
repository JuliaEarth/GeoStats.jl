# Overview

Below is a list of currently available geostatistical solvers.
Some of these solvers are distributed with GeoStats.jl, a.k.a.
"built-in" solvers, whereas other solvers are available in
separate packages, a.k.a. "external" solvers. If your solver
is not listed below, please submit a pull request and we will
be happy to review and add it to the list.

Solvers are organized into three categories: `estimation`, `simulation`
and `learning`. These categories correspond to the [Problems](../problems.md)
defined in the framework.

All `simulation` solvers below can generate realizations in parallel
on a cluster of computers unless otherwise noted. Please check the
documentation of [`solve`](@ref) for more details:

```@docs
solve(::SimulationProblem, ::SimulationSolver)
solvesingle
```

## Estimation

| Solver | Description | References |
|:------:|:------------|:-----------|
| [Kriging](https://github.com/JuliaEarth/GeoStatsSolvers.jl) | Kriging (SK, OK, UK, EDK) | [Matheron 1971](https://books.google.com/books/about/The_Theory_of_Regionalized_Variables_and.html?id=TGhGAAAAYAAJ) |
| [IDW](https://github.com/JuliaEarth/GeoStatsSolvers.jl) | Inverse distance weighting | [Shepard 1968](https://dl.acm.org/citation.cfm?id=810616) |
| [LWR](https://github.com/JuliaEarth/GeoStatsSolvers.jl) | Locally weighted regression | [Cleveland 1979](https://www.jstor.org/stable/2286407) |

## Simulation

### Gaussian

| Solver | Description | References |
|:------:|:------------|:-----------|
| [LUGS](https://github.com/JuliaEarth/GeoStatsSolvers.jl) | LU Gaussian simulation | [Alabert 1987](https://link.springer.com/article/10.1007/BF00897191) |
| [SGS](https://github.com/JuliaEarth/GeoStatsSolvers.jl) | Sequential Gaussian simulation | [Gómez-Hernández 1993](https://link.springer.com/chapter/10.1007/978-94-011-1739-5_8) |
| [FFTGS](https://github.com/JuliaEarth/GeoStatsSolvers.jl) | FFT Gaussian simulation | [Gutjahr 1997](https://link.springer.com/article/10.1007/BF02769641) |
| [SPDEGS](https://github.com/JuliaEarth/GeoStatsSolvers.jl) | SPDE Gaussian simulation | [Lindgren 2011](https://rss.onlinelibrary.wiley.com/doi/10.1111/j.1467-9868.2011.00777.x) |

### Non-Gaussian

| Solver | Description | References |
|:------:|:------------|:-----------|
| [IQ](https://github.com/JuliaEarth/ImageQuilting.jl) | Image quilting | [Hoffimann 2017](https://www.sciencedirect.com/science/article/pii/S0098300417301139) |
| [TPS](https://github.com/JuliaEarth/TuringPatterns.jl) | Turing patterns | [Turing 1952](https://royalsocietypublishing.org/doi/pdf/10.1098/rstb.1952.0012) |

### Meta

| Solver | Description | References |
|:------:|:------------|:-----------|
| [StratSim](https://github.com/JuliaEarth/StratiGraphics.jl) | Stratigraphy simulation | [Hoffimann 2018](https://searchworks.stanford.edu/view/12746435) |
| [CookieCutter](https://github.com/JuliaEarth/GeoStatsSolvers.jl) | Cookie-cutter simulation | [Begg 1992](https://www.onepetro.org/conference-paper/SPE-24698-MS) |

## Learning

| Solver | Description | References |
|:------:|:------------|:-----------|
| [PointwiseLearn](https://github.com/JuliaEarth/GeoStatsSolvers.jl) | Pointwise learning | [Hoffimann 2018](https://doi.org/10.21105/joss.00692) |
