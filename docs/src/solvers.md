# Solvers

If you are a developer and your solver is not listed below, please open a pull
request and we will be happy to review and add it to the list. Please check the
developer guide for instructions on how to write your own solvers.

## Estimation

| Solver | Build | Coverage | Description | References |
|:------:|:-----:|:--------:|:------------|:-----------|
| [Kriging](https://github.com/JuliaEarth/KrigingEstimators.jl) | [![](https://travis-ci.org/JuliaEarth/KrigingEstimators.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/KrigingEstimators.jl) | [![](https://codecov.io/gh/JuliaEarth/KrigingEstimators.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/KrigingEstimators.jl) | Kriging (SK, OK, UK, EDK) | [Matheron 1971](https://books.google.com/books/about/The_Theory_of_Regionalized_Variables_and.html?id=TGhGAAAAYAAJ) |
| [InvDistWeight](https://github.com/JuliaEarth/InverseDistanceWeighting.jl) | [![](https://travis-ci.org/JuliaEarth/InverseDistanceWeighting.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/InverseDistanceWeighting.jl) | [![](https://codecov.io/gh/JuliaEarth/InverseDistanceWeighting.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/InverseDistanceWeighting.jl) | Inverse distance weighting | [Shepard 1968](https://dl.acm.org/citation.cfm?id=810616) |
| [LocalWeightRegress](https://github.com/JuliaEarth/LocallyWeightedRegression.jl) | [![](https://travis-ci.org/JuliaEarth/LocallyWeightedRegression.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/LocallyWeightedRegression.jl) | [![](https://codecov.io/gh/JuliaEarth/LocallyWeightedRegression.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/LocallyWeightedRegression.jl) | Locally weighted regression | [Cleveland 1979](http://www.jstor.org/stable/2286407) |

## Simulation

All simulation solvers can generate realizations in parallel unless otherwise noted.

### Two-point

| Solver | Build | Coverage | Description | References |
|:------:|:-----:|:--------:|:------------|:-----------|
| [DirectGaussSim](https://github.com/JuliaEarth/DirectGaussianSimulation.jl) | [![](https://travis-ci.org/JuliaEarth/DirectGaussianSimulation.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/DirectGaussianSimulation.jl) | [![](https://codecov.io/gh/JuliaEarth/DirectGaussianSimulation.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/DirectGaussianSimulation.jl) | Direct Gaussian simulation | [Alabert 1987](https://link.springer.com/article/10.1007/BF00897191) |
| [SeqGaussSim](https://github.com/JuliaEarth/KrigingEstimators.jl) | [![](https://travis-ci.org/JuliaEarth/KrigingEstimators.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/KrigingEstimators.jl) | [![](https://codecov.io/gh/JuliaEarth/KrigingEstimators.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/KrigingEstimators.jl) | Sequential Gaussian simulation | [Gómez-Hernández 1993](https://link.springer.com/chapter/10.1007/978-94-011-1739-5_8) |
| [SpecGaussSim](https://github.com/JuliaEarth/SpectralGaussianSimulation.jl) | [![](https://travis-ci.org/JuliaEarth/SpectralGaussianSimulation.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/SpectralGaussianSimulation.jl) | [![](https://codecov.io/gh/JuliaEarth/SpectralGaussianSimulation.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/SpectralGaussianSimulation.jl) | Spectral Gaussian simulation | [Gutjahr 1997](https://link.springer.com/article/10.1007/BF02769641) |

### Multiple-point

| Solver | Build | Coverage | Description | References |
|:------:|:-----:|:--------:|:------------|:-----------|
| [ImgQuilt](https://github.com/JuliaEarth/ImageQuilting.jl) | [![](https://travis-ci.org/JuliaEarth/ImageQuilting.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/ImageQuilting.jl) | [![](https://codecov.io/gh/JuliaEarth/ImageQuilting.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/ImageQuilting.jl) | Image quilting | [Hoffimann 2017](http://www.sciencedirect.com/science/article/pii/S0098300417301139) |
| [TuringPat](https://github.com/yurivish/TuringPatterns.jl) | [![](https://travis-ci.org/yurivish/TuringPatterns.jl.svg?branch=master)](https://travis-ci.org/yurivish/TuringPatterns.jl) | [![](https://codecov.io/gh/yurivish/TuringPatterns.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/yurivish/TuringPatterns.jl) | Turing patterns | [Turing 1952](https://royalsocietypublishing.org/doi/pdf/10.1098/rstb.1952.0012) |

### Meta

| Solver | Build | Coverage | Description | References |
|:------:|:-----:|:--------:|:------------|:-----------|
| [StratSim](https://github.com/JuliaEarth/StratiGraphics.jl) | [![](https://travis-ci.org/JuliaEarth/StratiGraphics.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/StratiGraphics.jl) | [![](https://codecov.io/gh/JuliaEarth/StratiGraphics.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/StratiGraphics.jl) | Stratigraphy simulation | [Hoffimann 2018](https://searchworks.stanford.edu/view/12746435) |
| [CookieCutter](https://github.com/JuliaEarth/GeoStatsBase.jl) | [![](https://travis-ci.org/JuliaEarth/GeoStatsBase.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/GeoStatsBase.jl) | [![](https://codecov.io/gh/JuliaEarth/GeoStatsBase.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/GeoStatsBase.jl) | Cookie-cutter simulation | [Begg 1992](https://www.onepetro.org/conference-paper/SPE-24698-MS) |

## Learning

| Solver | Build | Coverage | Description | References |
|:------:|:-----:|:--------:|:------------|:-----------|
| [PointwiseLearn](https://github.com/JuliaEarth/GeoStatsBase.jl) | [![](https://travis-ci.org/JuliaEarth/GeoStatsBase.jl.svg?branch=master)](https://travis-ci.org/JuliaEarth/GeoStatsBase.jl) | [![](https://codecov.io/gh/JuliaEarth/GeoStatsBase.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/GeoStatsBase.jl) | Pointwise learning | [Hoffimann 2018](https://doi.org/10.21105/joss.00692) |
