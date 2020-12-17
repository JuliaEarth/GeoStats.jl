<p align="center">
  <img src="docs/src/assets/logo-text.svg" height="200"><br>
  <a href="https://github.com/JuliaEarth/GeoStats.jl/actions">
    <img src="https://img.shields.io/github/workflow/status/JuliaEarth/GeoStats.jl/CI?style=flat-square">
  </a>
  <a href="https://codecov.io/gh/JuliaEarth/GeoStats.jl">
    <img src="https://img.shields.io/codecov/c/github/JuliaEarth/GeoStats.jl?style=flat-square">
  </a>
  <a href="https://JuliaEarth.github.io/GeoStats.jl/stable">
    <img src="https://img.shields.io/badge/docs-stable-blue?style=flat-square">
  </a>
  <a href="https://JuliaEarth.github.io/GeoStats.jl/latest">
    <img src="https://img.shields.io/badge/docs-latest-blue?style=flat-square">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square">
  </a>
</p>
<p align="center">
  <a href="https://gitter.im/JuliaEarth/GeoStats.jl">
    <img src="https://img.shields.io/badge/chat-on%20gitter-bc0067?style=flat-square">
  </a>
  <a href="https://doi.org/10.21105/joss.00692">
    <img src="https://img.shields.io/badge/JOSS-10.21105%2Fjoss.00692-brightgreen?style=flat-square">
  </a>
  <a href="https://zenodo.org/badge/latestdoi/33827844">
    <img src="https://img.shields.io/badge/DOI-10.5281%2Fzenodo.3875233-blue?style=flat-square">
  </a>
</p>

# Project goals

- Design a comprehensive framework for geostatistics (or spatial statistics) in a modern programming language.
- Address the lack of a platform for scientific comparison of different geostatistical algorithms in the literature.
- Exploit modern hardware aggressively, including GPUs and computer clusters.
- Educate people outside of the field about the existence of geostatistics.

## Installation

Get the latest stable release with Julia's package manager:

```julia
] add GeoStats
```

## Documentation

- [**STABLE**][docs-stable-url] &mdash; **most recently tagged version of the documentation.**
- [**LATEST**][docs-latest-url] &mdash; *in-development version of the documentation.*

## Tutorials

A set of Jupyter notebooks demonstrating the current functionality of the project is available in
[GeoStatsTutorials](https://github.com/JuliaEarth/GeoStatsTutorials)
with an accompanying series of videos:

<p align="center">
  <a href="https://www.youtube.com/playlist?list=PLsH4hc788Z1f1e61DN3EV9AhDlpbhhanw">
    <img src="https://img.youtube.com/vi/yDIK9onnZVw/maxresdefault.jpg">
  </a>
</p>

Below is a quick preview of the high-level API:

```julia
using GeoStats
using Plots

# data.csv:
#    x,    y,       station,        precip
# 25.0, 25.0,     palo alto,           1.0
# 50.0, 75.0,  redwood city,           0.0
# 75.0, 50.0, mountain view,           1.0

# read spatial data (e.g. geotable)
𝒯 = readgeotable("data.csv", coordnames=(:x,:y))

# define spatial domain (e.g. regular grid)
𝒟 = RegularGrid(100, 100)

# define estimation problem for precipitation
𝒫 = EstimationProblem(𝒯, 𝒟, :precip)

# choose a solver from the list of solvers
𝒮 = Kriging(
  :precip => (variogram=GaussianVariogram(range=35.),)
)

# solve the problem
sol = solve(𝒫, 𝒮)

# plot the solution
contourf(sol)
```
<p align="center">
  <img src="docs/src/images/EstimationSolution.png">
</p>

## Contributing and supporting

Contributions are very welcome, as are feature requests and suggestions. Please
[open an issue](https://github.com/JuliaEarth/GeoStats.jl/issues) if you encounter
any problems. We have [written instructions](CONTRIBUTING.md) to help you with
the process.

If you have questions, don't hesitate to ask. Join our community in our
[gitter channel](https://gitter.im/JuliaEarth/GeoStats.jl). We are always
willing to help.

GeoStats.jl was developed as part of academic research. It will always be open
source and free of charge. If you would like to help support the project, please
star the repository [![STARS][stars-img]][stars-url] and share it with your colleagues.

## Citing

If you find GeoStats.jl useful in your work, please consider citing it:

[![JOSS][joss-img]][joss-url]
[![DOI][zenodo-img]][zenodo-url]

```bibtex
@ARTICLE{GeoStats.jl-2018,
  title={GeoStats.jl – High-performance geostatistics in Julia},
  author={Hoffimann, Júlio},
  journal={Journal of Open Source Software},
  publisher={The Open Journal},
  volume={3},
  pages={692},
  number={24},
  ISSN={2475-9066},
  DOI={10.21105/joss.00692},
  url={http://dx.doi.org/10.21105/joss.00692},
  year={2018},
  month={Apr}
}
```

## Used at

<p align="center">
  <img src="docs/src/images/Stanford.png" height="100">
  <img src="docs/src/images/IBM.png" height="100"><br><br>
  <img src="docs/src/images/ENI.png" height="150" hspace="20">
  <img src="docs/src/images/Petrobras.gif" height="150" hspace="20">
  <img src="docs/src/images/Deltares.png" height="150" hspace="20">
  <img src="docs/src/images/Nexa.jpg" height="150" hspace="20">
</p>

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue?style=flat-square
[docs-stable-url]: https://JuliaEarth.github.io/GeoStats.jl/stable

[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue?style=flat-square
[docs-latest-url]: https://JuliaEarth.github.io/GeoStats.jl/latest

[joss-img]: https://img.shields.io/badge/JOSS-10.21105%2Fjoss.00692-brightgreen?style=flat-square
[joss-url]: https://doi.org/10.21105/joss.00692

[zenodo-img]: https://img.shields.io/badge/DOI-10.5281%2Fzenodo.3875233-blue?style=flat-square
[zenodo-url]: https://zenodo.org/badge/latestdoi/33827844

[stars-img]: https://img.shields.io/github/stars/JuliaEarth/GeoStats.jl?style=social
[stars-url]: https://github.com/JuliaEarth/GeoStats.jl

## Contributors

This project would not be possible without the contributions of:

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://www.evetion.nl"><img src="https://avatars0.githubusercontent.com/u/8655030?v=4" width="100px;" alt=""/><br /><sub><b>Maarten Pronk</b></sub></a><br /><a href="#infra-evetion" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
    <td align="center"><a href="https://github.com/visr"><img src="https://avatars1.githubusercontent.com/u/4471859?v=4" width="100px;" alt=""/><br /><sub><b>Martijn Visser</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=visr" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/fredrikekre"><img src="https://avatars2.githubusercontent.com/u/11698744?v=4" width="100px;" alt=""/><br /><sub><b>Fredrik Ekre</b></sub></a><br /><a href="#infra-fredrikekre" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
    <td align="center"><a href="http://dldx.org"><img src="https://avatars2.githubusercontent.com/u/107700?v=4" width="100px;" alt=""/><br /><sub><b>Durand D'souza</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=dldx" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/mortenpi"><img src="https://avatars1.githubusercontent.com/u/147757?v=4" width="100px;" alt=""/><br /><sub><b>Morten Piibeleht</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=mortenpi" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/tkelman"><img src="https://avatars0.githubusercontent.com/u/5934628?v=4" width="100px;" alt=""/><br /><sub><b>Tony Kelman</b></sub></a><br /><a href="#infra-tkelman" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
    <td align="center"><a href="https://www.linkedin.com/in/madnansiddique/"><img src="https://avatars0.githubusercontent.com/u/8629089?v=4" width="100px;" alt=""/><br /><sub><b>M. A. Siddique</b></sub></a><br /><a href="#question-masiddique" title="Answering Questions">💬</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/asinghvi17"><img src="https://avatars1.githubusercontent.com/u/32143268?v=4" width="100px;" alt=""/><br /><sub><b>Anshul Singhvi</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=asinghvi17" title="Documentation">📖</a></td>
    <td align="center"><a href="https://zdroid.github.io"><img src="https://avatars2.githubusercontent.com/u/2725611?v=4" width="100px;" alt=""/><br /><sub><b>Zlatan Vasović</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=zdroid" title="Documentation">📖</a></td>
    <td align="center"><a href="https://www.bpasquier.com/"><img src="https://avatars2.githubusercontent.com/u/4486578?v=4" width="100px;" alt=""/><br /><sub><b>Benoit Pasquier</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=briochemc" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/exepulveda"><img src="https://avatars2.githubusercontent.com/u/5109252?v=4" width="100px;" alt=""/><br /><sub><b>exepulveda</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=exepulveda" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/errearanhas"><img src="https://avatars1.githubusercontent.com/u/12888985?v=4" width="100px;" alt=""/><br /><sub><b>Renato Aranha</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=errearanhas" title="Tests">⚠️</a></td>
    <td align="center"><a href="http://pkofod.com/"><img src="https://avatars0.githubusercontent.com/u/8431156?v=4" width="100px;" alt=""/><br /><sub><b>Patrick Kofod Mogensen</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=pkofod" title="Code">💻</a></td>
    <td align="center"><a href="http://xuk.ai"><img src="https://avatars1.githubusercontent.com/u/5985769?v=4" width="100px;" alt=""/><br /><sub><b>Kai Xu</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=xukai92" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/PaulMatlashewski"><img src="https://avatars1.githubusercontent.com/u/13931255?v=4" width="100px;" alt=""/><br /><sub><b>Paul Matlashewski</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=PaulMatlashewski" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/riyadm"><img src="https://avatars1.githubusercontent.com/u/38479955?v=4" width="100px;" alt=""/><br /><sub><b>Riyad Muradov</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=riyadm" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/ammilten"><img src="https://avatars0.githubusercontent.com/u/29921747?v=4" width="100px;" alt=""/><br /><sub><b>Alex Miltenberger</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=ammilten" title="Code">💻</a></td>
    <td align="center"><a href="https://www.linkedin.com/in/LakshyaKhatri"><img src="https://avatars1.githubusercontent.com/u/28972442?v=4" width="100px;" alt=""/><br /><sub><b>Lakshya Khatri</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=LakshyaKhatri" title="Code">💻</a></td>
    <td align="center"><a href="http://bouchet-valat.site.ined.fr"><img src="https://avatars3.githubusercontent.com/u/1120448?v=4" width="100px;" alt=""/><br /><sub><b>Milan Bouchet-Valat</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=nalimilan" title="Documentation">📖</a></td>
    <td align="center"><a href="http://www.linkedin.com/in/rmcaixeta"><img src="https://avatars3.githubusercontent.com/u/8386288?v=4" width="100px;" alt=""/><br /><sub><b>Rafael Caixeta</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=rmcaixeta" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/ElOceanografo"><img src="https://avatars3.githubusercontent.com/u/1072448?v=4" width="100px;" alt=""/><br /><sub><b>Sam</b></sub></a><br /><a href="#infra-ElOceanografo" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
  </tr>
  <tr>
    <td align="center"><a href="http://nitishgadangi.github.io"><img src="https://avatars0.githubusercontent.com/u/29014716?v=4" width="100px;" alt=""/><br /><sub><b>Nitish Gadangi</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=NitishGadangi" title="Documentation">📖</a> <a href="#infra-NitishGadangi" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
    <td align="center"><a href="https://github.com/Mattriks"><img src="https://avatars0.githubusercontent.com/u/18226881?v=4" width="100px;" alt=""/><br /><sub><b>Mattriks</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=Mattriks" title="Code">💻</a></td>
    <td align="center"><a href="https://cormullion.github.io"><img src="https://avatars1.githubusercontent.com/u/52289?v=4" width="100px;" alt=""/><br /><sub><b>cormullion</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=cormullion" title="Documentation">📖</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->
