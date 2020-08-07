<p align="center">
  <img src="docs/src/assets/logo-text.svg" height="200"><br>
  <a href="https://travis-ci.org/JuliaEarth/GeoStats.jl">
    <img src="https://travis-ci.org/JuliaEarth/GeoStats.jl.svg?branch=master">
  </a>
  <a href="https://codecov.io/gh/JuliaEarth/GeoStats.jl">
    <img src="https://codecov.io/gh/JuliaEarth/GeoStats.jl/branch/master/graph/badge.svg">
  </a>
  <a href="https://JuliaEarth.github.io/GeoStats.jl/stable">
    <img src="https://img.shields.io/badge/docs-stable-blue.svg">
  </a>
  <a href="https://JuliaEarth.github.io/GeoStats.jl/latest">
    <img src="https://img.shields.io/badge/docs-latest-blue.svg">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-ISC-blue.svg">
  </a>
</p>
<p align="center">
  <a href="https://gitter.im/JuliaEarth/GeoStats.jl">
    <img src="https://img.shields.io/badge/chat-on%20gitter-bc0067.svg">
  </a>
  <a href="https://doi.org/10.21105/joss.00692">
    <img src="http://joss.theoj.org/papers/10.21105/joss.00692/status.svg">
  </a>
  <a href="https://zenodo.org/badge/latestdoi/33827844">
    <img src="https://zenodo.org/badge/33827844.svg">
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
#    x,    y,       station, precipitation
# 25.0, 25.0,     palo alto,           1.0
# 50.0, 75.0,  redwood city,           0.0
# 75.0, 50.0, mountain view,           1.0

# read spreadsheet file containing spatial data
sdata = readgeotable("data.csv", coordnames=[:x,:y])

# define spatial domain (e.g. regular grid)
sdomain = RegularGrid(100, 100)

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
star the repository and share it with your colleagues.

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
  <img src="docs/src/images/Deltares.png" height="150" hspace="20">
  <img src="docs/src/images/ENI.png" height="150" hspace="20">
</p>

[travis-img]: https://travis-ci.org/JuliaEarth/GeoStats.jl.svg?branch=master
[travis-url]: https://travis-ci.org/JuliaEarth/GeoStats.jl

[julia-pkg-img]: http://pkg.julialang.org/badges/GeoStats_0.7.svg
[julia-pkg-url]: http://pkg.julialang.org/?pkg=GeoStats

[codecov-img]: https://codecov.io/gh/JuliaEarth/GeoStats.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/JuliaEarth/GeoStats.jl

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://JuliaEarth.github.io/GeoStats.jl/stable

[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://JuliaEarth.github.io/GeoStats.jl/latest

[license-img]: https://img.shields.io/badge/license-ISC-blue.svg
[license-url]: LICENSE

[gitter-img]: https://img.shields.io/badge/chat-on%20gitter-bc0067.svg
[gitter-url]: https://gitter.im/JuliaEarth/GeoStats.jl

[joss-img]: http://joss.theoj.org/papers/10.21105/joss.00692/status.svg
[joss-url]: https://doi.org/10.21105/joss.00692

[zenodo-img]: https://zenodo.org/badge/33827844.svg
[zenodo-url]: https://zenodo.org/badge/latestdoi/33827844

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://www.evetion.nl"><img src="https://avatars0.githubusercontent.com/u/8655030?v=4" width="100px;" alt=""/><br /><sub><b>Maarten Pronk</b></sub></a><br /><a href="#infra-evetion" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
