<p align="center">
  <img src="docs/src/assets/logo-text.svg" height="200"><br>
  <a href="https://github.com/JuliaEarth/GeoStats.jl/actions">
    <img src="https://img.shields.io/github/actions/workflow/status/JuliaEarth/GeoStats.jl/CI.yml?branch=master&style=flat-square">
  </a>
  <a href="https://julialang.zulipchat.com/#narrow/stream/276201-geostats.2Ejl">
    <img src="https://img.shields.io/badge/chat-on%20zulip-9cf?style=flat-square">
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
  <a href="https://doi.org/10.21105/joss.00692">
    <img src="https://img.shields.io/badge/JOSS-10.21105%2Fjoss.00692-brightgreen?style=flat-square">
  </a>
  <a href="https://zenodo.org/badge/latestdoi/33827844">
    <img src="https://img.shields.io/badge/DOI-10.5281%2Fzenodo.3875233-blue?style=flat-square">
  </a>
</p>

# Project goals

- Design a comprehensive framework for geostatistics in a modern programming language.
- Address the lack of a platform for scientific comparison of different geostatistical
  algorithms in the literature.
- Exploit modern hardware aggressively, including GPUs and computer clusters.
- Educate people outside of the field about the existence of geostatistics.

For a guided tour, please watch our JuliaCon2021 talk and our JuliaEO2023 workshop:

<p align="center">
  <a href="https://youtu.be/75A6zyn5pIE">
    <img src="https://img.youtube.com/vi/75A6zyn5pIE/maxresdefault.jpg">
  </a>
</p>

<p align="center">
  <a href="https://youtu.be/1FfgjW5XQ9g">
    <img src="https://img.youtube.com/vi/1FfgjW5XQ9g/maxresdefault.jpg">
  </a>
</p>

## Contributing and supporting

Contributions are very welcome, as are feature requests and suggestions. Please
[open an issue](https://github.com/JuliaEarth/GeoStats.jl/issues) if you encounter
any problems. We have [written instructions](CONTRIBUTING.md) to help you with
the process.

GeoStats.jl was developed as part of academic research. It will always be open
source and free of charge. If you would like to help support the project, please
star the repository [![STARS][stars-img]][stars-url] and share it with your colleagues.
If you have questions, don't hesitate to ask in our community channel:

[![ZULIP][zulip-img]][zulip-url]

## Citing

If you find GeoStats.jl useful in your work, please consider citing it:

[![JOSS][joss-img]][joss-url]
[![DOI][zenodo-img]][zenodo-url]

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
  url={http://dx.doi.org/10.21105/joss.00692},
  year={2018},
  month={Apr}
}
```

## Installation

Get the latest stable release with Julia's package manager:

```
] add GeoStats
```

## Documentation

- [**STABLE**][docs-stable-url] &mdash; **most recently tagged version of the documentation.**
- [**LATEST**][docs-latest-url] &mdash; *in-development version of the documentation.*

## Tutorials

A set of Pluto notebooks demonstrating the current functionality of the project is available in
[GeoStatsTutorials](https://github.com/JuliaEarth/GeoStatsTutorials)
with an accompanying series of videos:

<p align="center">
  <a href="https://www.youtube.com/playlist?list=PLsH4hc788Z1f1e61DN3EV9AhDlpbhhanw">
    <img src="https://img.youtube.com/vi/yDIK9onnZVw/maxresdefault.jpg">
  </a>
</p>

## Used at

<p align="center">
  <img src="docs/src/images/Petrobras.gif" width="160px" hspace="20">
  <img src="docs/src/images/Vale.png" width="160px" hspace="20">
  <img src="docs/src/images/Gazprom.png" width="160px" hspace="20">
  <img src="docs/src/images/Nexa.jpg" width="160px" hspace="20">
  <img src="docs/src/images/ENI.png" width="100px" hspace="20">
  <img src="docs/src/images/Stanford.png" width="300px" hspace="20">
  <img src="docs/src/images/UFMG.jpg" width="160px" hspace="20">
</p>

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue?style=flat-square
[docs-stable-url]: https://JuliaEarth.github.io/GeoStats.jl/stable

[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue?style=flat-square
[docs-latest-url]: https://JuliaEarth.github.io/GeoStats.jl/latest

[joss-img]: https://img.shields.io/badge/JOSS-10.21105%2Fjoss.00692-brightgreen?style=flat-square
[joss-url]: https://doi.org/10.21105/joss.00692

[zenodo-img]: https://img.shields.io/badge/DOI-10.5281%2Fzenodo.3875233-blue?style=flat-square
[zenodo-url]: https://zenodo.org/badge/latestdoi/33827844

[zulip-img]: https://img.shields.io/badge/chat-on%20zulip-9cf?style=flat-square
[zulip-url]: https://julialang.zulipchat.com/#narrow/stream/276201-geostats.2Ejl

[stars-img]: https://img.shields.io/github/stars/JuliaEarth/GeoStats.jl?style=social
[stars-url]: https://github.com/JuliaEarth/GeoStats.jl

## Contributors

This project would not be possible without the contributions of:

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://www.evetion.nl"><img src="https://avatars0.githubusercontent.com/u/8655030?v=4?s=100" width="100px;" alt="Maarten Pronk"/><br /><sub><b>Maarten Pronk</b></sub></a><br /><a href="#infra-evetion" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/visr"><img src="https://avatars1.githubusercontent.com/u/4471859?v=4?s=100" width="100px;" alt="Martijn Visser"/><br /><sub><b>Martijn Visser</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=visr" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/fredrikekre"><img src="https://avatars2.githubusercontent.com/u/11698744?v=4?s=100" width="100px;" alt="Fredrik Ekre"/><br /><sub><b>Fredrik Ekre</b></sub></a><br /><a href="#infra-fredrikekre" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://dldx.org"><img src="https://avatars2.githubusercontent.com/u/107700?v=4?s=100" width="100px;" alt="Durand D'souza"/><br /><sub><b>Durand D'souza</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=dldx" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/mortenpi"><img src="https://avatars1.githubusercontent.com/u/147757?v=4?s=100" width="100px;" alt="Morten Piibeleht"/><br /><sub><b>Morten Piibeleht</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=mortenpi" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/tkelman"><img src="https://avatars0.githubusercontent.com/u/5934628?v=4?s=100" width="100px;" alt="Tony Kelman"/><br /><sub><b>Tony Kelman</b></sub></a><br /><a href="#infra-tkelman" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/madnansiddique/"><img src="https://avatars0.githubusercontent.com/u/8629089?v=4?s=100" width="100px;" alt="M. A. Siddique"/><br /><sub><b>M. A. Siddique</b></sub></a><br /><a href="#question-masiddique" title="Answering Questions">💬</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/asinghvi17"><img src="https://avatars1.githubusercontent.com/u/32143268?v=4?s=100" width="100px;" alt="Anshul Singhvi"/><br /><sub><b>Anshul Singhvi</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=asinghvi17" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://zdroid.github.io"><img src="https://avatars2.githubusercontent.com/u/2725611?v=4?s=100" width="100px;" alt="Zlatan Vasović"/><br /><sub><b>Zlatan Vasović</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=zdroid" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.bpasquier.com/"><img src="https://avatars2.githubusercontent.com/u/4486578?v=4?s=100" width="100px;" alt="Benoit Pasquier"/><br /><sub><b>Benoit Pasquier</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=briochemc" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/exepulveda"><img src="https://avatars2.githubusercontent.com/u/5109252?v=4?s=100" width="100px;" alt="exepulveda"/><br /><sub><b>exepulveda</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=exepulveda" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/errearanhas"><img src="https://avatars1.githubusercontent.com/u/12888985?v=4?s=100" width="100px;" alt="Renato Aranha"/><br /><sub><b>Renato Aranha</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=errearanhas" title="Tests">⚠️</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://pkofod.com/"><img src="https://avatars0.githubusercontent.com/u/8431156?v=4?s=100" width="100px;" alt="Patrick Kofod Mogensen"/><br /><sub><b>Patrick Kofod Mogensen</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=pkofod" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://xuk.ai"><img src="https://avatars1.githubusercontent.com/u/5985769?v=4?s=100" width="100px;" alt="Kai Xu"/><br /><sub><b>Kai Xu</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=xukai92" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/PaulMatlashewski"><img src="https://avatars1.githubusercontent.com/u/13931255?v=4?s=100" width="100px;" alt="Paul Matlashewski"/><br /><sub><b>Paul Matlashewski</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=PaulMatlashewski" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/riyadm"><img src="https://avatars1.githubusercontent.com/u/38479955?v=4?s=100" width="100px;" alt="Riyad Muradov"/><br /><sub><b>Riyad Muradov</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=riyadm" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ammilten"><img src="https://avatars0.githubusercontent.com/u/29921747?v=4?s=100" width="100px;" alt="Alex Miltenberger"/><br /><sub><b>Alex Miltenberger</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=ammilten" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/LakshyaKhatri"><img src="https://avatars1.githubusercontent.com/u/28972442?v=4?s=100" width="100px;" alt="Lakshya Khatri"/><br /><sub><b>Lakshya Khatri</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=LakshyaKhatri" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://bouchet-valat.site.ined.fr"><img src="https://avatars3.githubusercontent.com/u/1120448?v=4?s=100" width="100px;" alt="Milan Bouchet-Valat"/><br /><sub><b>Milan Bouchet-Valat</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=nalimilan" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://www.linkedin.com/in/rmcaixeta"><img src="https://avatars3.githubusercontent.com/u/8386288?v=4?s=100" width="100px;" alt="Rafael Caixeta"/><br /><sub><b>Rafael Caixeta</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=rmcaixeta" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ElOceanografo"><img src="https://avatars3.githubusercontent.com/u/1072448?v=4?s=100" width="100px;" alt="Sam"/><br /><sub><b>Sam</b></sub></a><br /><a href="#infra-ElOceanografo" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="http://nitishgadangi.github.io"><img src="https://avatars0.githubusercontent.com/u/29014716?v=4?s=100" width="100px;" alt="Nitish Gadangi"/><br /><sub><b>Nitish Gadangi</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=NitishGadangi" title="Documentation">📖</a> <a href="#infra-NitishGadangi" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Mattriks"><img src="https://avatars0.githubusercontent.com/u/18226881?v=4?s=100" width="100px;" alt="Mattriks"/><br /><sub><b>Mattriks</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=Mattriks" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://cormullion.github.io"><img src="https://avatars1.githubusercontent.com/u/52289?v=4?s=100" width="100px;" alt="cormullion"/><br /><sub><b>cormullion</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=cormullion" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://maurow.bitbucket.io/"><img src="https://avatars1.githubusercontent.com/u/4098145?v=4?s=100" width="100px;" alt="Mauro"/><br /><sub><b>Mauro</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=mauro3" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/cyborg1995"><img src="https://avatars.githubusercontent.com/u/55525317?v=4?s=100" width="100px;" alt="Gaurav Wasnik"/><br /><sub><b>Gaurav Wasnik</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=cyborg1995" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/atreyamaj"><img src="https://avatars.githubusercontent.com/u/14348863?v=4?s=100" width="100px;" alt="Atreya Majumdar"/><br /><sub><b>Atreya Majumdar</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=atreyamaj" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/hameye"><img src="https://avatars.githubusercontent.com/u/57682091?v=4?s=100" width="100px;" alt="Hadrien Meyer"/><br /><sub><b>Hadrien Meyer</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=hameye" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/felixcremer"><img src="https://avatars.githubusercontent.com/u/17124431?v=4?s=100" width="100px;" alt="Felix Cremer"/><br /><sub><b>Felix Cremer</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=felixcremer" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://storopoli.io"><img src="https://avatars.githubusercontent.com/u/43353831?v=4?s=100" width="100px;" alt="Jose Storopoli"/><br /><sub><b>Jose Storopoli</b></sub></a><br /><a href="#infra-storopoli" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/fnaghetini"><img src="https://avatars.githubusercontent.com/u/63740520?v=4?s=100" width="100px;" alt="Franco Naghetini"/><br /><sub><b>Franco Naghetini</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=fnaghetini" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.nicholasshea.com/"><img src="https://avatars.githubusercontent.com/u/25097799?v=4?s=100" width="100px;" alt="Nicholas Shea"/><br /><sub><b>Nicholas Shea</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=nshea3" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://math.mit.edu/~stevenj"><img src="https://avatars.githubusercontent.com/u/2913679?v=4?s=100" width="100px;" alt="Steven G. Johnson"/><br /><sub><b>Steven G. Johnson</b></sub></a><br /><a href="#infra-stevengj" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/mrr00b00t"><img src="https://avatars.githubusercontent.com/u/32930332?v=4?s=100" width="100px;" alt="José A. S. Silva"/><br /><sub><b>José A. S. Silva</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=mrr00b00t" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/marlonsmathias"><img src="https://avatars.githubusercontent.com/u/81258808?v=4?s=100" width="100px;" alt="Marlon Sproesser Mathias"/><br /><sub><b>Marlon Sproesser Mathias</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=marlonsmathias" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/eliascarv"><img src="https://avatars.githubusercontent.com/u/73039601?v=4?s=100" width="100px;" alt="Elias Carvalho"/><br /><sub><b>Elias Carvalho</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=eliascarv" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ClaroHenrique"><img src="https://avatars.githubusercontent.com/u/38709777?v=4?s=100" width="100px;" alt="ClaroHenrique"/><br /><sub><b>ClaroHenrique</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=ClaroHenrique" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/decarvalhojunior-fh"><img src="https://avatars.githubusercontent.com/u/102302676?v=4?s=100" width="100px;" alt="decarvalhojunior-fh"/><br /><sub><b>decarvalhojunior-fh</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=decarvalhojunior-fh" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/DianaPat"><img src="https://avatars.githubusercontent.com/u/105749646?v=4?s=100" width="100px;" alt="DianaPat"/><br /><sub><b>DianaPat</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=DianaPat" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jwscook"><img src="https://avatars.githubusercontent.com/u/15519866?v=4?s=100" width="100px;" alt="James Cook"/><br /><sub><b>James Cook</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=jwscook" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/vickydeka"><img src="https://avatars.githubusercontent.com/u/48693415?v=4?s=100" width="100px;" alt="vickydeka"/><br /><sub><b>vickydeka</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=vickydeka" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/lihua-cat"><img src="https://avatars.githubusercontent.com/u/42488653?v=4?s=100" width="100px;" alt="刘昊"/><br /><sub><b>刘昊</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=lihua-cat" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/stla"><img src="https://avatars.githubusercontent.com/u/4466543?v=4?s=100" width="100px;" alt="stla"/><br /><sub><b>stla</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=stla" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/dorn-gerhard"><img src="https://avatars.githubusercontent.com/u/67096719?v=4?s=100" width="100px;" alt="Gerhard Dorn"/><br /><sub><b>Gerhard Dorn</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=dorn-gerhard" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jackbeagley"><img src="https://avatars.githubusercontent.com/u/15933842?v=4?s=100" width="100px;" alt="Jack Beagley"/><br /><sub><b>Jack Beagley</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=jackbeagley" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/cserteGT3"><img src="https://avatars.githubusercontent.com/u/26418354?v=4?s=100" width="100px;" alt="cserteGT3"/><br /><sub><b>cserteGT3</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=cserteGT3" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://kylebeggs.com"><img src="https://avatars.githubusercontent.com/u/24981811?v=4?s=100" width="100px;" alt="Kyle Beggs"/><br /><sub><b>Kyle Beggs</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=kylebeggs" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://erickchacon.gitlab.io/"><img src="https://avatars.githubusercontent.com/u/7862458?v=4?s=100" width="100px;" alt="Dr. Erick A. Chacón Montalván"/><br /><sub><b>Dr. Erick A. Chacón Montalván</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=ErickChacon" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/mfsch"><img src="https://avatars.githubusercontent.com/u/3769324?v=4?s=100" width="100px;" alt="Manuel Schmid"/><br /><sub><b>Manuel Schmid</b></sub></a><br /><a href="https://github.com/JuliaEarth/GeoStats.jl/commits?author=mfsch" title="Code">💻</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
