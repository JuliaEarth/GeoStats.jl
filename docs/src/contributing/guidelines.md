# Guidelines

First off, thank you for considering contributing to GeoStats.jl.
It’s people like you that make this project so much fun.
Below are a few suggestions to speed up the collaboration process:

- Please be polite, we are here to help and learn from each other.
- Try to explain your contribution with simple language.
- References to textbooks and papers are always welcome.
- Follow the coding standards in the source.

## How to start contributing?

Contributing to an open-source project for the very first time can be a very daunting task.
To make the process easier and more GitHub-beginner-friendly, the community has written
an [article](https://invenia.github.io/blog/2021/01/29/contribute-open-source) about how
to start contributing to open-source and overcome the mental and technical barriers that
come associated with it. The article will also take you through the steps required to make
your [first contribution](https://github.com/firstcontributions/first-contributions) in detail.

## Reporting issues

If you are experiencing issues or have discovered a bug, please
report it on GitHub. To make the resolution process easier, please
include the version of Julia and GeoStats.jl in your writeup.
These can be found with two commands:

```julia
julia> versioninfo()
julia> using Pkg; Pkg.status()
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
user environment. Next, go ahead and type:

```julia
] dev GeoStatsBase
] dev Variography
] dev KrigingEstimators
] dev PointPatterns
] dev GeoClustering
] dev GeoEstimation
] dev GeoSimulation
] dev GeoLearning
] dev GeoStats
```

to clone all the project components in your `~/.julia` folder.
You can modify the source code and submit a pull request on
GitHub later.
