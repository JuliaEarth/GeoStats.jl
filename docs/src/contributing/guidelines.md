# Guidelines

First off, thank you for considering contributing to GeoStats.jl.
It’s people like you that make this project so much fun.
Below are a few suggestions to speed up the collaboration process.

## Reporting issues

If you are experiencing issues or have discovered a bug, please
report it on GitHub. To make the resolution process easier, please
include the version of Julia and GeoStats.jl in your writeup.
These can be found with two commands:

```julia
julia> versioninfo()
pkg> status
```

## Feature requests

If you have suggestions of improvement or algorithms that you would like
to see implemented in GeoStats.jl, please open an issue on GitHub.
Suggestions as well as feature requests are very welcome.

## Code contribution

If you have code that you would like to contribute to GeoStats.jl,
that is awesome! Please [open an issue](https://github.com/JuliaEarth/GeoStats.jl/issues)
before you create the pull request on GitHub so that we make sure
your idea is aligned with our goals for the project.

After your idea is discussed and revised by maintainers, please get
the development version of the project by typing the following in
the package manager:

```julia
] activate @geo
```

This will create a fresh environment called `@geo` where you can
play with the project components without compromising your normal
user environment.

```julia
] dev GeoStatsBase Variography KrigingEstimators GeoEstimation GaussianSimulation PointPatterns GeoStats
```

This will clone all the project components in your `~/.julia` folder so
that you can modify it and submit a pull request on GitHub later. Don't
hesitate to ask questions in our [gitter channel](https://gitter.im/JuliaEarth/GeoStats.jl)
if you are not familiar with the Git workflow. We are looking forward
to your contributions.
