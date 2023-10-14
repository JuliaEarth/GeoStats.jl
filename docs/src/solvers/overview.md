# Overview

Below is a list of currently available geostatistical solvers.
Some of these solvers are distributed with GeoStats.jl, a.k.a.
"built-in" solvers, whereas other solvers are available in
separate packages, a.k.a. "external" solvers. If your solver
is not listed below, please submit a pull request and we will
be happy to review and add it to the list.

Solvers are organized into categories: `simulation` and `learning`.
These categories correspond to the [Problems](../problems.md)
defined in the framework. All solvers implement the [`solve`](@ref) function:

```@docs
solve
solvesingle
```

### Distributed computing

All `simulation` solvers can generate realizations in parallel
using multiple Julia processes. Doing so requires using the
[Distributed](https://docs.julialang.org/en/v1/stdlib/Distributed/)
standard library, like in the following example:

```julia
using Distributed

# request additional processes
addprocs(3)

# load code on every single process
@everywhere using GeoStats

# ------------
# main script
# ------------

table = (Z=[1.,0.,1.],)
coord = [(25.,25.), (50.,75.), (75.,50.)]

𝒟 = georef(table, coord)
𝒢 = CartesianGrid(100, 100)

𝒫 = SimulationProblem(𝒟, 𝒢, :Z, 3)
𝒮 = LUGS(:Z => (variogram=GaussianVariogram(range=35),))

# solve on all available processes
Ω = solve(𝒫, 𝒮, procs=workers())
```

Please consult
[The ultimate guide to distributed computing in Julia](https://github.com/Arpeggeo/julia-distributed-computing/tree/master).

## Simulation

### Gaussian

| Solver | Description | References |
|:------:|:------------|:-----------|
| [`LUGS`](@ref) | LU Gaussian simulation | [Alabert 1987](https://link.springer.com/article/10.1007/BF00897191) |
| [`SGS`](@ref) | Sequential Gaussian simulation | [Gómez-Hernández 1993](https://link.springer.com/chapter/10.1007/978-94-011-1739-5_8) |
| [`FFTGS`](@ref) | FFT Gaussian simulation | [Gutjahr 1997](https://link.springer.com/article/10.1007/BF02769641) |
| [`SPDEGS`](@ref) | SPDE Gaussian simulation | [Lindgren 2011](https://rss.onlinelibrary.wiley.com/doi/10.1111/j.1467-9868.2011.00777.x) |

### Non-Gaussian

| Solver | Description | References |
|:------:|:------------|:-----------|
| [`IQ`](@ref) | Image quilting | [Hoffimann 2017](https://www.sciencedirect.com/science/article/pii/S0098300417301139) |
| [`TPS`](@ref) | Turing patterns | [Turing 1952](https://royalsocietypublishing.org/doi/pdf/10.1098/rstb.1952.0012) |

### Meta

| Solver | Description | References |
|:------:|:------------|:-----------|
| [`StratSim`](@ref) | Stratigraphy simulation | [Hoffimann 2018](https://searchworks.stanford.edu/view/12746435) |
| [`CookieCutter`](@ref) | Cookie-cutter simulation | [Begg 1992](https://www.onepetro.org/conference-paper/SPE-24698-MS) |

## Learning

| Solver | Description | References |
|:------:|:------------|:-----------|
| [`PointwiseLearn`](@ref) | Pointwise learning | [Hoffimann 2021](https://www.frontiersin.org/articles/10.3389/fams.2021.689393/full) |
