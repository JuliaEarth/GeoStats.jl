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
interp |> viewer
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
| [GeoArtifacts.jl](https://github.com/JuliaEarth/GeoArtifacts.jl) | Artifacts (e.g., datasets) for geospatial data science. |
| [GeoStatsImages.jl](https://github.com/JuliaEarth/GeoStatsImages.jl) | Training images for geostatistical simulation. |
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

```@raw html
<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://www.evetion.nl"><img src="https://avatars0.githubusercontent.com/u/8655030?v=4?s=70" width="70px;" alt="Maarten Pronk"/><br /><sub><b>Maarten Pronk</b></sub></a><br /><a href="#infra-evetion" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/visr"><img src="https://avatars1.githubusercontent.com/u/4471859?v=4?s=70" width="70px;" alt="Martijn Visser"/><br /><sub><b>Martijn Visser</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=visr" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/fredrikekre"><img src="https://avatars2.githubusercontent.com/u/11698744?v=4?s=70" width="70px;" alt="Fredrik Ekre"/><br /><sub><b>Fredrik Ekre</b></sub></a><br /><a href="#infra-fredrikekre" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://dldx.org"><img src="https://avatars2.githubusercontent.com/u/107700?v=4?s=70" width="70px;" alt="Durand D'souza"/><br /><sub><b>Durand D'souza</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=dldx" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/mortenpi"><img src="https://avatars1.githubusercontent.com/u/147757?v=4?s=70" width="70px;" alt="Morten Piibeleht"/><br /><sub><b>Morten Piibeleht</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=mortenpi" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/tkelman"><img src="https://avatars0.githubusercontent.com/u/5934628?v=4?s=70" width="70px;" alt="Tony Kelman"/><br /><sub><b>Tony Kelman</b></sub></a><br /><a href="#infra-tkelman" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/madnansiddique/"><img src="https://avatars0.githubusercontent.com/u/8629089?v=4?s=70" width="70px;" alt="M. A. Siddique"/><br /><sub><b>M. A. Siddique</b></sub></a><br /><a href="#question-masiddique" title="Answering Questions">💬</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/asinghvi17"><img src="https://avatars1.githubusercontent.com/u/32143268?v=4?s=70" width="70px;" alt="Anshul Singhvi"/><br /><sub><b>Anshul Singhvi</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=asinghvi17" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://zdroid.github.io"><img src="https://avatars2.githubusercontent.com/u/2725611?v=4?s=70" width="70px;" alt="Zlatan Vasović"/><br /><sub><b>Zlatan Vasović</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=zdroid" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.bpasquier.com/"><img src="https://avatars2.githubusercontent.com/u/4486578?v=4?s=70" width="70px;" alt="Benoit Pasquier"/><br /><sub><b>Benoit Pasquier</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=briochemc" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/exepulveda"><img src="https://avatars2.githubusercontent.com/u/5109252?v=4?s=70" width="70px;" alt="exepulveda"/><br /><sub><b>exepulveda</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=exepulveda" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/errearanhas"><img src="https://avatars1.githubusercontent.com/u/12888985?v=4?s=70" width="70px;" alt="Renato Aranha"/><br /><sub><b>Renato Aranha</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=errearanhas" title="Tests">⚠️</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://pkofod.com/"><img src="https://avatars0.githubusercontent.com/u/8431156?v=4?s=70" width="70px;" alt="Patrick Kofod Mogensen"/><br /><sub><b>Patrick Kofod Mogensen</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=pkofod" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://xuk.ai"><img src="https://avatars1.githubusercontent.com/u/5985769?v=4?s=70" width="70px;" alt="Kai Xu"/><br /><sub><b>Kai Xu</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=xukai92" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/PaulMatlashewski"><img src="https://avatars1.githubusercontent.com/u/13931255?v=4?s=70" width="70px;" alt="Paul Matlashewski"/><br /><sub><b>Paul Matlashewski</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=PaulMatlashewski" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/riyadm"><img src="https://avatars1.githubusercontent.com/u/38479955?v=4?s=70" width="70px;" alt="Riyad Muradov"/><br /><sub><b>Riyad Muradov</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=riyadm" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ammilten"><img src="https://avatars0.githubusercontent.com/u/29921747?v=4?s=70" width="70px;" alt="Alex Miltenberger"/><br /><sub><b>Alex Miltenberger</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=ammilten" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/LakshyaKhatri"><img src="https://avatars1.githubusercontent.com/u/28972442?v=4?s=70" width="70px;" alt="Lakshya Khatri"/><br /><sub><b>Lakshya Khatri</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=LakshyaKhatri" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://bouchet-valat.site.ined.fr"><img src="https://avatars3.githubusercontent.com/u/1120448?v=4?s=70" width="70px;" alt="Milan Bouchet-Valat"/><br /><sub><b>Milan Bouchet-Valat</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=nalimilan" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://www.linkedin.com/in/rmcaixeta"><img src="https://avatars3.githubusercontent.com/u/8386288?v=4?s=70" width="70px;" alt="Rafael Caixeta"/><br /><sub><b>Rafael Caixeta</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=rmcaixeta" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ElOceanografo"><img src="https://avatars3.githubusercontent.com/u/1072448?v=4?s=70" width="70px;" alt="Sam"/><br /><sub><b>Sam</b></sub></a><br /><a href="#infra-ElOceanografo" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="http://nitishgadangi.github.io"><img src="https://avatars0.githubusercontent.com/u/29014716?v=4?s=70" width="70px;" alt="Nitish Gadangi"/><br /><sub><b>Nitish Gadangi</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=NitishGadangi" title="Documentation">📖</a> <a href="#infra-NitishGadangi" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Mattriks"><img src="https://avatars0.githubusercontent.com/u/18226881?v=4?s=70" width="70px;" alt="Mattriks"/><br /><sub><b>Mattriks</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=Mattriks" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://cormullion.github.io"><img src="https://avatars1.githubusercontent.com/u/52289?v=4?s=70" width="70px;" alt="cormullion"/><br /><sub><b>cormullion</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=cormullion" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://maurow.bitbucket.io/"><img src="https://avatars1.githubusercontent.com/u/4098145?v=4?s=70" width="70px;" alt="Mauro"/><br /><sub><b>Mauro</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=mauro3" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/cyborg1995"><img src="https://avatars.githubusercontent.com/u/55525317?v=4?s=70" width="70px;" alt="Gaurav Wasnik"/><br /><sub><b>Gaurav Wasnik</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=cyborg1995" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/atreyamaj"><img src="https://avatars.githubusercontent.com/u/14348863?v=4?s=70" width="70px;" alt="Atreya Majumdar"/><br /><sub><b>Atreya Majumdar</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=atreyamaj" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/hameye"><img src="https://avatars.githubusercontent.com/u/57682091?v=4?s=70" width="70px;" alt="Hadrien Meyer"/><br /><sub><b>Hadrien Meyer</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=hameye" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/felixcremer"><img src="https://avatars.githubusercontent.com/u/17124431?v=4?s=70" width="70px;" alt="Felix Cremer"/><br /><sub><b>Felix Cremer</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=felixcremer" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://storopoli.io"><img src="https://avatars.githubusercontent.com/u/43353831?v=4?s=70" width="70px;" alt="Jose Storopoli"/><br /><sub><b>Jose Storopoli</b></sub></a><br /><a href="#infra-storopoli" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/fnaghetini"><img src="https://avatars.githubusercontent.com/u/63740520?v=4?s=70" width="70px;" alt="Franco Naghetini"/><br /><sub><b>Franco Naghetini</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=fnaghetini" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.nicholasshea.com/"><img src="https://avatars.githubusercontent.com/u/25097799?v=4?s=70" width="70px;" alt="Nicholas Shea"/><br /><sub><b>Nicholas Shea</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=nshea3" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://math.mit.edu/~stevenj"><img src="https://avatars.githubusercontent.com/u/2913679?v=4?s=70" width="70px;" alt="Steven G. Johnson"/><br /><sub><b>Steven G. Johnson</b></sub></a><br /><a href="#infra-stevengj" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/mrr00b00t"><img src="https://avatars.githubusercontent.com/u/32930332?v=4?s=70" width="70px;" alt="José A. S. Silva"/><br /><sub><b>José A. S. Silva</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=mrr00b00t" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/marlonsmathias"><img src="https://avatars.githubusercontent.com/u/81258808?v=4?s=70" width="70px;" alt="Marlon Sproesser Mathias"/><br /><sub><b>Marlon Sproesser Mathias</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=marlonsmathias" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/eliascarv"><img src="https://avatars.githubusercontent.com/u/73039601?v=4?s=70" width="70px;" alt="Elias Carvalho"/><br /><sub><b>Elias Carvalho</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=eliascarv" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ClaroHenrique"><img src="https://avatars.githubusercontent.com/u/38709777?v=4?s=70" width="70px;" alt="ClaroHenrique"/><br /><sub><b>ClaroHenrique</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=ClaroHenrique" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/decarvalhojunior-fh"><img src="https://avatars.githubusercontent.com/u/102302676?v=4?s=70" width="70px;" alt="decarvalhojunior-fh"/><br /><sub><b>decarvalhojunior-fh</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=decarvalhojunior-fh" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/DianaPat"><img src="https://avatars.githubusercontent.com/u/105749646?v=4?s=70" width="70px;" alt="DianaPat"/><br /><sub><b>DianaPat</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=DianaPat" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jwscook"><img src="https://avatars.githubusercontent.com/u/15519866?v=4?s=70" width="70px;" alt="James Cook"/><br /><sub><b>James Cook</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=jwscook" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/vickydeka"><img src="https://avatars.githubusercontent.com/u/48693415?v=4?s=70" width="70px;" alt="vickydeka"/><br /><sub><b>vickydeka</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=vickydeka" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/lihua-cat"><img src="https://avatars.githubusercontent.com/u/42488653?v=4?s=70" width="70px;" alt="刘昊"/><br /><sub><b>刘昊</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=lihua-cat" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/stla"><img src="https://avatars.githubusercontent.com/u/4466543?v=4?s=70" width="70px;" alt="stla"/><br /><sub><b>stla</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=stla" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/dorn-gerhard"><img src="https://avatars.githubusercontent.com/u/67096719?v=4?s=70" width="70px;" alt="Gerhard Dorn"/><br /><sub><b>Gerhard Dorn</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=dorn-gerhard" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jackbeagley"><img src="https://avatars.githubusercontent.com/u/15933842?v=4?s=70" width="70px;" alt="Jack Beagley"/><br /><sub><b>Jack Beagley</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=jackbeagley" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/cserteGT3"><img src="https://avatars.githubusercontent.com/u/26418354?v=4?s=70" width="70px;" alt="cserteGT3"/><br /><sub><b>cserteGT3</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=cserteGT3" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://kylebeggs.com"><img src="https://avatars.githubusercontent.com/u/24981811?v=4?s=70" width="70px;" alt="Kyle Beggs"/><br /><sub><b>Kyle Beggs</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=kylebeggs" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://erickchacon.gitlab.io/"><img src="https://avatars.githubusercontent.com/u/7862458?v=4?s=70" width="70px;" alt="Dr. Erick A. Chacón Montalván"/><br /><sub><b>Dr. Erick A. Chacón Montalván</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=ErickChacon" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/mfsch"><img src="https://avatars.githubusercontent.com/u/3769324?v=4?s=70" width="70px;" alt="Manuel Schmid"/><br /><sub><b>Manuel Schmid</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=mfsch" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/longemen3000"><img src="https://avatars.githubusercontent.com/u/38795484?v=4?s=70" width="70px;" alt="Andrés Riedemann"/><br /><sub><b>Andrés Riedemann</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=longemen3000" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://hyrodium.github.io"><img src="https://avatars.githubusercontent.com/u/7488140?v=4?s=70" width="70px;" alt="Yuto Horikawa"/><br /><sub><b>Yuto Horikawa</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=hyrodium" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/conordoherty"><img src="https://avatars.githubusercontent.com/u/5650772?v=4?s=70" width="70px;" alt="Conor Doherty"/><br /><sub><b>Conor Doherty</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=conordoherty" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/spaette"><img src="https://avatars.githubusercontent.com/u/111918424?v=4?s=70" width="70px;" alt="spaette"/><br /><sub><b>spaette</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=spaette" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ashwani-rathee"><img src="https://avatars.githubusercontent.com/u/54855463?v=4?s=70" width="70px;" alt="Ashwani Rathee"/><br /><sub><b>Ashwani Rathee</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=ashwani-rathee" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://astroautomata.com"><img src="https://avatars.githubusercontent.com/u/7593028?v=4?s=70" width="70px;" alt="Miles Cranmer"/><br /><sub><b>Miles Cranmer</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=MilesCranmer" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/DanielVandH"><img src="https://avatars.githubusercontent.com/u/95613936?v=4?s=70" width="70px;" alt="Daniel VandenHeuvel"/><br /><sub><b>Daniel VandenHeuvel</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=DanielVandH" title="Documentation">📖</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/chrstphrbrns"><img src="https://avatars.githubusercontent.com/u/19110911?v=4?s=70" width="70px;" alt="Christopher Burns"/><br /><sub><b>Christopher Burns</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=chrstphrbrns" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/essamwisam/"><img src="https://avatars.githubusercontent.com/u/49572294?v=4?s=70" width="70px;" alt="Essam"/><br /><sub><b>Essam</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=EssamWisam" title="Code">💻</a> <a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=EssamWisam" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/luschiro"><img src="https://avatars.githubusercontent.com/u/56177321?v=4?s=70" width="70px;" alt="Lucas R. Schiavetti"/><br /><sub><b>Lucas R. Schiavetti</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/issues?q=author%3Aluschiro" title="Bug reports">🐛</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://ehgus.github.io/"><img src="https://avatars.githubusercontent.com/u/18534737?v=4?s=70" width="70px;" alt="Lee, Dohyeon"/><br /><sub><b>Lee, Dohyeon</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=ehgus" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Jay-sanjay"><img src="https://avatars.githubusercontent.com/u/134289328?v=4?s=70" width="70px;" alt="Jay-sanjay"/><br /><sub><b>Jay-sanjay</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=Jay-sanjay" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/remann2"><img src="https://avatars.githubusercontent.com/u/139355838?v=4?s=70" width="70px;" alt="Steve"/><br /><sub><b>Steve</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=remann2" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/MachSilva"><img src="https://avatars.githubusercontent.com/u/25288575?v=4?s=70" width="70px;" alt="Felipe Silva"/><br /><sub><b>Felipe Silva</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=MachSilva" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ajahraus"><img src="https://avatars.githubusercontent.com/u/9949357?v=4?s=70" width="70px;" alt="Adam J"/><br /><sub><b>Adam J</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=ajahraus" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://ziotom78.blogspot.it/"><img src="https://avatars.githubusercontent.com/u/377795?v=4?s=70" width="70px;" alt="Maurizio Tomasi"/><br /><sub><b>Maurizio Tomasi</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=ziotom78" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/markmbaum"><img src="https://avatars.githubusercontent.com/u/18745581?v=4?s=70" width="70px;" alt="Mark Baum"/><br /><sub><b>Mark Baum</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=markmbaum" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://page.romeov.me"><img src="https://avatars.githubusercontent.com/u/8644490?v=4?s=70" width="70px;" alt="RomeoV"/><br /><sub><b>RomeoV</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=RomeoV" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/BambOoxX"><img src="https://avatars.githubusercontent.com/u/42067365?v=4?s=70" width="70px;" alt="BambOoxX"/><br /><sub><b>BambOoxX</b></sub></a><br /><a href="#infra-BambOoxX" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://ettersi.github.io"><img src="https://avatars.githubusercontent.com/u/2989007?v=4?s=70" width="70px;" alt="Simon Etter"/><br /><sub><b>Simon Etter</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=ettersi" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.remivezy.com/"><img src="https://avatars.githubusercontent.com/u/12777793?v=4?s=70" width="70px;" alt="Rémi Vezy"/><br /><sub><b>Rémi Vezy</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=VEZY" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/disberd"><img src="https://avatars.githubusercontent.com/u/12846528?v=4?s=70" width="70px;" alt="Alberto Mengali"/><br /><sub><b>Alberto Mengali</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=disberd" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.math.uni-hamburg.de/en/home/lampert"><img src="https://avatars.githubusercontent.com/u/51029046?v=4?s=70" width="70px;" alt="Joshua Lampert"/><br /><sub><b>Joshua Lampert</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=JoshuaLampert" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://salbalkus.github.io/"><img src="https://avatars.githubusercontent.com/u/45985925?v=4?s=70" width="70px;" alt="Salvador Balkus"/><br /><sub><b>Salvador Balkus</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=salbalkus" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/TimG1964"><img src="https://avatars.githubusercontent.com/u/157401228?v=4?s=70" width="70px;" alt="TimG1964"/><br /><sub><b>TimG1964</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=TimG1964" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/romu545"><img src="https://avatars.githubusercontent.com/u/76394912?v=4?s=70" width="70px;" alt="Rafael Mendoza Ureche"/><br /><sub><b>Rafael Mendoza Ureche</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=romu545" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/simon-kok-lupemba-434099162/"><img src="https://avatars.githubusercontent.com/u/30597266?v=4?s=70" width="70px;" alt="Simon Kok Lupemba"/><br /><sub><b>Simon Kok Lupemba</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=lupemba" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/uriele"><img src="https://avatars.githubusercontent.com/u/2747130?v=4?s=70" width="70px;" alt="Marco"/><br /><sub><b>Marco</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=uriele" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="http://davibarreira.github.io"><img src="https://avatars.githubusercontent.com/u/6407557?v=4?s=70" width="70px;" alt="Davi Sales Barreira"/><br /><sub><b>Davi Sales Barreira</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=davibarreira" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/mikeingold"><img src="https://avatars.githubusercontent.com/u/4054970?v=4?s=70" width="70px;" alt="Michael Ingold"/><br /><sub><b>Michael Ingold</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=mikeingold" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/stepanoslejsek"><img src="https://avatars.githubusercontent.com/u/102300007?v=4?s=70" width="70px;" alt="Štěpán Ošlejšek"/><br /><sub><b>Štěpán Ošlejšek</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=stepanoslejsek" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/souma4"><img src="https://avatars.githubusercontent.com/u/91837445?v=4?s=70" width="70px;" alt="Jeffrey Chandler"/><br /><sub><b>Jeffrey Chandler</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=souma4" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/CarlBittendorf"><img src="https://avatars.githubusercontent.com/u/85636219?v=4?s=70" width="70px;" alt="Carl Bittendorf"/><br /><sub><b>Carl Bittendorf</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=CarlBittendorf" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ghyatzo"><img src="https://avatars.githubusercontent.com/u/8601724?v=4?s=70" width="70px;" alt="cschen"/><br /><sub><b>cschen</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=ghyatzo" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://jthatch.com"><img src="https://avatars.githubusercontent.com/u/2112477?v=4?s=70" width="70px;" alt="Thatcher Chamberlin"/><br /><sub><b>Thatcher Chamberlin</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=ThatcherC" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="http://omar-elrefaei.github.io"><img src="https://avatars.githubusercontent.com/u/17922991?v=4?s=70" width="70px;" alt="Omar Elrefaei"/><br /><sub><b>Omar Elrefaei</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=Omar-Elrefaei" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/EdoKara"><img src="https://avatars.githubusercontent.com/u/112835719?v=4?s=70" width="70px;" alt="Andrew Brown"/><br /><sub><b>Andrew Brown</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=EdoKara" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://halleysfifthinc.github.io"><img src="https://avatars.githubusercontent.com/u/7356205?v=4?s=70" width="70px;" alt="Allen Hill"/><br /><sub><b>Allen Hill</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=halleysfifthinc" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/nsajko"><img src="https://avatars.githubusercontent.com/u/4944410?v=4?s=70" width="70px;" alt="Neven Sajko"/><br /><sub><b>Neven Sajko</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=nsajko" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jamesalster"><img src="https://avatars.githubusercontent.com/u/83536617?v=4?s=70" width="70px;" alt="jamesalster"/><br /><sub><b>jamesalster</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=jamesalster" title="Code">💻</a> <a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=jamesalster" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://luminescentai.com"><img src="https://avatars.githubusercontent.com/u/13193130?v=4?s=70" width="70px;" alt="Paul Shen"/><br /><sub><b>Paul Shen</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=paulxshen" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://www.debsankha.net/"><img src="https://avatars.githubusercontent.com/u/313429?v=4?s=70" width="70px;" alt="Debsankha Manik"/><br /><sub><b>Debsankha Manik</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=debsankha" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/tcarion"><img src="https://avatars.githubusercontent.com/u/42749284?v=4?s=70" width="70px;" alt="Tristan Carion"/><br /><sub><b>Tristan Carion</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=tcarion" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/bencherian"><img src="https://avatars.githubusercontent.com/u/9374201?v=4?s=70" width="70px;" alt="Benjamin Cherian"/><br /><sub><b>Benjamin Cherian</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=bencherian" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://fabianbarrett.github.io/"><img src="https://avatars.githubusercontent.com/u/22241119?v=4?s=70" width="70px;" alt="Ben Barrett"/><br /><sub><b>Ben Barrett</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=FabianBarrett" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://davidmetivier.mistea.inrae.fr/"><img src="https://avatars.githubusercontent.com/u/46794064?v=4?s=70" width="70px;" alt="David Métivier"/><br /><sub><b>David Métivier</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=dmetivie" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/marcosdanieldasilva"><img src="https://avatars.githubusercontent.com/u/135757954?v=4?s=70" width="70px;" alt="Marcos Daniel da Silva"/><br /><sub><b>Marcos Daniel da Silva</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=marcosdanieldasilva" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/henry2004y"><img src="https://avatars.githubusercontent.com/u/20110816?v=4?s=70" width="70px;" alt="Hongyang Zhou"/><br /><sub><b>Hongyang Zhou</b></sub></a><br /><a href="#infra-henry2004y" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
```
