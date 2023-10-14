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
to see implemented, please open an issue on GitHub. Suggestions as well
as feature requests are very welcome.

## Code contribution

If you have code that you would like to contribute that is awesome!
Please [open an issue](https://github.com/JuliaEarth/GeoStats.jl/issues)
or reach out in our community channel before you create the pull request
on GitHub so that we make sure your idea is aligned with the project goals.

After your idea is revised by project maintainers, you implement it online
on Github or offline on your machine.

### Online changes

If the changes to the code are minimal, we recommend pressing `.` on the
keyboard on any file in the GitHub repository of interest. This will open
the VSCode editor on the web browser where you can implement the changes,
commit them and submit a pull request.

### Offline changes

If the changes require additional investigation and tests, please
get the development version of the project by typing the following in
the package manager:

```
] activate @geo
```

This will create a fresh environment called `@geo` where you can
edit the project modules without effects on your global user
environment. Next, go ahead and ask the package manager to
develop the package of interest (e.g. Variography.jl):

```
] dev Variography
```

You can modify the source code that was cloned in the `.julia/dev`
folder and submit a pull request on GitHub later.
