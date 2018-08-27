---
title: 'GeoStats.jl -- High-performance geostatistics in Julia'
tags:
  - Geostatistics
  - Inverse problems
  - Random processes
  - Spatial statistics
  - Variography
  - Kriging
  - Estimation
  - Simulation
  - Julia
authors:
  - name: Júlio Hoffimann (juliohm@stanford.edu)
    orcid: 0000-0003-2789-297X
    affiliation: 1
affiliations:
  - name: Stanford University
    index: 1
date: 20 April 2018
bibliography: paper.bib
---

# Summary

[GeoStats.jl](https://github.com/juliohm/GeoStats.jl) is an extensible framework
for high-performance geostatistics in Julia, as well as a formal specification of
statistical problems in the spatial setting. It provides highly optimized solvers
for estimation and (conditional) simulation of variables defined over general spatial
domains (e.g. regular grid, point collection), and can utilize high-performance
hardware for parallel execution such as GPUs and computer clusters.

Its unique design addresses the very important issue of scientific comparison
between different geostatistical methods proposed by the research community.
Unlike similar software (e.g. GSLIB, SGeMS, gstat), which implement algorithms
for specific data and domain types with varying interfaces, GeoStats.jl
introduces an abstraction layer with which users can define their problems
precisely once, and switch between different solvers effortlessly. The same
abstraction layer enables the development of higher-order routines that operate
on solvers as first-class objects (e.g. cross-validation), a feature that gives
researchers the ability to experiment with various geomodeling assumptions
programatically.

Besides its technical contributions, the project aims to educate people outside
of the field about state-of-the-art methods in geostatistics, their assumptions,
and their limitations.

## Problem types

The framework currently defines two types of problems:

- **Estimation:** given spatial data and domain, estimate variable(s) at unseen locations,
and provide whenever possible a variance (or uncertainty) map.

- **Simulation:** given domain and (optionally) spatial data, simulate multiple realizations
of variable(s) matching previously existing data if present.

## Available solvers

As of version 0.6, the following solvers are available.

- Estimation solvers

    * Kriging [@Matheron1971]
    * Inverse Distance Weighting [@Shepard1968]
    * Locally Weighted Regression [@Cleveland1979]

- Simulation solvers

    * Direct Gaussian Simulation [@Alabert1987]
    * Sequential Gaussian Simulation [@Isaaks1990]
    * Fast Image Quilting [@Hoffimann2017]

# Example of usage

```julia
using GeoStats
using Plots

# data.csv:
#    x,    y,       station, precipitation
# 25.0, 25.0,     palo alto,           1.0
# 50.0, 75.0,  redwood city,           0.0
# 75.0, 50.0, mountain view,           1.0

# read spreadsheet file containing spatial data
geodata = readgeotable("data.csv", coordnames=[:x,:y])

# define spatial domain (e.g. regular grid, point collection)
grid = RegularGrid{Float64}(100, 100)

# define estimation problem for any data column(s) (e.g. :precipitation)
problem = EstimationProblem(geodata, grid, :precipitation)

# choose a solver from the list of solvers
solver = Kriging(
  :precipitation => @NT(variogram=GaussianVariogram(range=35.))
)

# solve the problem
solution = solve(problem, solver)

# plot the solution
plot(solution)
```
\begin{figure}[h!]\centering
  {\includegraphics[width=\textwidth]{EstimationSolution.png}}
  \caption{Estimation solution on a regular grid.}
\end{figure}

# Straightforward scientific comparison of solvers

Solvers adhering to the interface proposed in the framework can be
easily compared on a given problem with different comparison methods.
From a user's perspective, this feature facilitates the selection of
solvers for a specific problem. From a researcher's perspective, this
feature serves to guide the efforts of the geostatistics community.

```julia
using GeoStats
using Plots

# define solvers to be compared
solver1 = Kriging(
    :precipitation => @NT(variogram=GaussianVariogram(range=35.))
)
solver2 = InvDistWeight()

# compare solvers with a comparison method (e.g. visual comparison)
compare([solver1, solver2], problem, VisualComparison())
```
\begin{figure}[h!]\centering
  {\includegraphics[width=.8\textwidth]{SolverComparison.png}}
  \caption{Visual comparison of solvers.}
\end{figure}

As of version 0.6, the following comparison methods are available.

- Visual Comparison
- k-fold Cross-Validation

# Usage in academia and industry

The solvers and tools implemented in the project have been used in both academic and industrial endeavours.
To give an example, the [ImageQuilting.jl](https://github.com/juliohm/ImageQuilting.jl)
[@Hoffimann2017] solver has been used inside [ENI](https://www.eni.com)
to condition 3D process-based models to data acquired in Oil \& Gas fields.
It has also been used by researchers in Denmark interested in modeling groundwater
resources [@Barfod2017], and by researchers studying micromodels of porous medium
in various research groups worldwise. Research colleagues at Stanford are currently
using GeoStats.jl to model fractured reservoirs, mineral deposits, geothermal resources,
and glaciers, among other spatial objects.

# Acknowledgements

I'd like to thank my research colleagues in the School of Earth Sciences at Stanford
for their feedback, feature requests, and bug reports, as well as the Julia community
for helping with internal design decisions.

# Funding

GeoStats.jl will always be open source and free of charge. If you are an organization
that supports open source initiatives, please contact the author at
\href{mailto:juliohm@stanford.edu}{juliohm@stanford.edu} regarding funding opportunities.

# References
