# Solvers

If you are a developer and your solver is not listed below, please open a pull
request and we will be happy to review and add it to the list. Please check the
developer guide for instructions on how to write your own solvers.

## Estimation

| Solver | Coverage | Description | References |
|:------:|:--------:|:------------|:-----------|
| [Kriging](https://github.com/JuliaEarth/KrigingEstimators.jl) | [![](https://img.shields.io/codecov/c/github/JuliaEarth/KrigingEstimators.jl?style=flat-square)](https://codecov.io/gh/JuliaEarth/KrigingEstimators.jl) | Kriging (SK, OK, UK, EDK) | [Matheron 1971](https://books.google.com/books/about/The_Theory_of_Regionalized_Variables_and.html?id=TGhGAAAAYAAJ) |
| [IDW](https://github.com/JuliaEarth/GeoEstimation.jl) | [![](https://img.shields.io/codecov/c/github/JuliaEarth/GeoEstimation.jl?style=flat-square)](https://codecov.io/gh/JuliaEarth/GeoEstimation.jl) | Inverse distance weighting | [Shepard 1968](https://dl.acm.org/citation.cfm?id=810616) |
| [LWR](https://github.com/JuliaEarth/GeoEstimation.jl) | [![](https://img.shields.io/codecov/c/github/JuliaEarth/GeoEstimation.jl?style=flat-square)](https://codecov.io/gh/JuliaEarth/GeoEstimation.jl) | Locally weighted regression | [Cleveland 1979](https://www.jstor.org/stable/2286407) |

## Simulation

All simulation solvers can generate realizations in parallel unless otherwise noted.

### Two-point

| Solver | Coverage | Description | References |
|:------:|:--------:|:------------|:-----------|
| [LUGS](https://github.com/JuliaEarth/GaussianSimulation.jl) | [![](https://img.shields.io/codecov/c/github/JuliaEarth/GaussianSimulation.jl?style=flat-square)](https://codecov.io/gh/JuliaEarth/GaussianSimulation.jl) | LU Gaussian simulation | [Alabert 1987](https://link.springer.com/article/10.1007/BF00897191) |
| [SGS](https://github.com/JuliaEarth/GaussianSimulation.jl) | [![](https://img.shields.io/codecov/c/github/JuliaEarth/GaussianSimulation.jl?style=flat-square)](https://codecov.io/gh/JuliaEarth/GaussianSimulation.jl) | Sequential Gaussian simulation | [Gómez-Hernández 1993](https://link.springer.com/chapter/10.1007/978-94-011-1739-5_8) |
| [FFTGS](https://github.com/JuliaEarth/GaussianSimulation.jl) | [![](https://img.shields.io/codecov/c/github/JuliaEarth/GaussianSimulation.jl?style=flat-square)](https://codecov.io/gh/JuliaEarth/GaussianSimulation.jl) | FFT Gaussian simulation | [Gutjahr 1997](https://link.springer.com/article/10.1007/BF02769641) |

### Multiple-point

| Solver | Coverage | Description | References |
|:------:|:--------:|:------------|:-----------|
| [IQ](https://github.com/JuliaEarth/ImageQuilting.jl) | [![](https://img.shields.io/codecov/c/github/JuliaEarth/ImageQuilting.jl?style=flat-square)](https://codecov.io/gh/JuliaEarth/ImageQuilting.jl) | Image quilting | [Hoffimann 2017](https://www.sciencedirect.com/science/article/pii/S0098300417301139) |
| [TPS](https://github.com/yurivish/TuringPatterns.jl) | [![](https://img.shields.io/codecov/c/github/yurivish/TuringPatterns.jl?style=flat-square)](https://codecov.io/gh/yurivish/TuringPatterns.jl) | Turing patterns | [Turing 1952](https://royalsocietypublishing.org/doi/pdf/10.1098/rstb.1952.0012) |

### Meta

| Solver | Coverage | Description | References |
|:------:|:--------:|:------------|:-----------|
| [StratSim](https://github.com/JuliaEarth/StratiGraphics.jl) | [![](https://img.shields.io/codecov/c/github/JuliaEarth/StratiGraphics.jl?style=flat-square)](https://codecov.io/gh/JuliaEarth/StratiGraphics.jl) | Stratigraphy simulation | [Hoffimann 2018](https://searchworks.stanford.edu/view/12746435) |
| [CookieCutter](https://github.com/JuliaEarth/GeoStatsBase.jl) | [![](https://img.shields.io/codecov/c/github/JuliaEarth/GeoStatsBase.jl?style=flat-square)](https://codecov.io/gh/JuliaEarth/GeoStatsBase.jl) | Cookie-cutter simulation | [Begg 1992](https://www.onepetro.org/conference-paper/SPE-24698-MS) |

## Learning

| Solver | Coverage | Description | References |
|:------:|:--------:|:------------|:-----------|
| [PointwiseLearn](https://github.com/JuliaEarth/GeoStatsBase.jl) | [![](https://img.shields.io/codecov/c/github/JuliaEarth/GeoStatsBase.jl?style=flat-square)](https://codecov.io/gh/JuliaEarth/GeoStatsBase.jl) | Pointwise learning | [Hoffimann 2018](https://doi.org/10.21105/joss.00692) |
