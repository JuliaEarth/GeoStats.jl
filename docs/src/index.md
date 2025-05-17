```@docs
GeoStats
```

!!! note "Star us on GitHub!"

    If you have found this software useful, please consider starring it on
    [GitHub](https://github.com/JuliaEarth/GeoStats.jl). This gives us an
    accurate lower bound of the (satisfied) user count.

Organizations using the framework:

```@raw html
<p align="center">
  <img src="images/Petrobras.gif" width="160px" hspace="20">
  <img src="images/Vale.png" width="160px" hspace="20">
  <img src="images/Gazprom.png" width="160px" hspace="20">
  <img src="images/Nexa.jpg" width="160px" hspace="20">
  <img src="images/ENI.png" width="100px" hspace="20">
  <img src="images/Stanford.png" width="300px" hspace="20">
  <img src="images/UFMG.jpg" width="160px" hspace="20">
</p>
```

### Sponsors

```@raw html
<p align="center">
  <a href="https://arpeggeo.tech">
    <img src="images/Arpeggeo.png" width="200px" hspace="20">
  </a>
</p>
```

Would like to become a sponsor? Press the sponsor button in our
[GitHub repository](https://github.com/JuliaEarth/GeoStats.jl).

## Overview

In many fields of science, such as mining engineering, hydrogeology, petroleum
engineering, and environmental sciences, traditional statistical methods fail
to provide unbiased estimates of resources due to the presence of geospatial
association. Geostatistics (a.k.a. geospatial statistics) is the branch of
statistics developed to overcome this limitation. Particularly, it is the
branch that takes geospatial coordinates of data into account. Some major
highlights of **GeoStats.jl** are:

- It is **simple**: has a very short learning curve and requires writing minimal code 😌
- It is **general**: supports all types of geospatial domains, including unstructured meshes 👍
- It is **native**: fully written in Julia for maximum flexibility and performance 🚀
- Has an **extensive library** of algorithms from the geostatistics literature 📚

The following table generated on March 11, 2025 provides a
general comparison with other software:

```@raw html
<p align="center">
  <img src="images/SoftwareComparison.png" width="100%" hspace="20">
</p>
```

Our JuliaCon2021 talk provides an overview of
[geostatistical learning](https://www.frontiersin.org/journals/applied-mathematics-and-statistics/articles/10.3389/fams.2021.689393/full),
which is one of the many geostatistical problems addressed
by the framework:

```@raw html
<p align="center">
<iframe style="width:560px;height:315px" src="https://www.youtube.com/embed/75A6zyn5pIE" title="Geostatistical Learning" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</p>
```

Consider reading the [Geospatial Data Science with Julia](https://juliaearth.github.io/geospatial-data-science-with-julia)
book before reading this documentation. If you have questions, or would
like to brainstorm ideas, don't hesitate to start a topic in our
[community channel](about/community.md).

```@raw html
<p align="center">
  <a href="https://juliaearth.github.io/geospatial-data-science-with-julia">
    <img src="https://juliaearth.github.io/geospatial-data-science-with-julia/images/cover.svg" width="300px" hspace="20">
  </a>
</p>
```

## Installation

Get the latest stable release with Julia's package manager:

```julia
using Pkg
Pkg.add("GeoStats")
```

## Quick example

Below is an example of geostatistical interpolation of point data
over a Cartesian grid with a Kriging model:

```@example overview
# load framework
using GeoStats

# load visualization backend
import CairoMakie as Mke

# attribute table
table = (; z=[1.,0.,1.])

# coordinates for each row
coord = [(25.,25.), (50.,75.), (75.,50.)]

# georeference data
geotable = georef(table, coord)

# interpolation domain
grid = CartesianGrid(100, 100)

# choose an interpolation model
model = Kriging(GaussianVariogram(range=35.))

# perform interpolation over grid
interp = geotable |> Interpolate(grid, model=model)

# visualize the solution
viz(interp.geometry, color = interp.z)
```

## Project organization

The project is split into various packages:

| Package | Description |
|:-------:|:------------|
| [GeoStats.jl](https://github.com/JuliaEarth/GeoStats.jl) | Main package reexporting full stack of packages for geostatistics. |
| [Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl) | Computational geometry and advanced meshing algorithms. |
| [CoordRefSystems.jl](https://github.com/JuliaEarth/CoordRefSystems.jl) | Unitful coordinate reference systems. |
| [CoordGridTransforms.jl](https://github.com/JuliaEarth/CoordGridTransforms.jl) | Coordinate transforms with offset grids. |
| [GeoTables.jl](https://github.com/JuliaEarth/GeoTables.jl) | Geospatial tables compatible with the framework. |
| [DataScienceTraits.jl](https://github.com/JuliaML/DataScienceTraits.jl) | Traits for geospatial data science. |
| [TableTransforms.jl](https://github.com/JuliaML/TableTransforms.jl) | Transforms and pipelines with tabular data. |
| [StatsLearnModels.jl](https://github.com/JuliaML/StatsLearnModels.jl) | Statistical learning models for geospatial prediction. |
| [GeoStatsBase.jl](https://github.com/JuliaEarth/GeoStatsBase.jl) | Base package with core geostatistical definitions. |
| [GeoStatsFunctions.jl](https://github.com/JuliaEarth/GeoStatsFunctions.jl) | Geostatistical functions and related tools. |
| [GeoStatsModels.jl](https://github.com/JuliaEarth/GeoStatsModels.jl) | Geostatistical models for geospatial interpolation. |
| [GeoStatsProcesses.jl](https://github.com/JuliaEarth/GeoStatsProcesses.jl) | Geostatistical processes for geospatial simulation. |
| [GeoStatsTransforms.jl](https://github.com/JuliaEarth/GeoStatsTransforms.jl) | Geostatistical transforms for geospatial data. |
| [GeoStatsValidation.jl](https://github.com/JuliaEarth/GeoStatsValidation.jl) | Geostatistical validation methods. |

Other packages can be installed separately for additional functionality:

| Package | Description |
|:-------:|:------------|
| [GeoIO.jl](https://github.com/JuliaEarth/GeoIO.jl) | Load/save geospatial tables in various formats. |
| [GeoArtifacts.jl](https://github.com/JuliaEarth/GeoArtifacts.jl) | Artifacts for geospatial data science. |
| [DrillHoles.jl](https://github.com/JuliaEarth/DrillHoles.jl) | Desurvey/composite drillhole data. |

## Citing the software

If you find this software useful in your work, please consider citing it: 

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

## Contributors

This project would not be possible without the contributions of:

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
