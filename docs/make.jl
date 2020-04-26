# Workaround for GR warnings
ENV["GKSwstype"] = "100"

using Documenter, GeoStats
using DocumenterTools: Themes

istravis = "TRAVIS" ∈ keys(ENV)

Themes.compile(joinpath(@__DIR__,"src/assets/geostats-light.scss"), joinpath(@__DIR__,"src/assets/themes/documenter-light.css"))
Themes.compile(joinpath(@__DIR__,"src/assets/geostats-dark.scss"), joinpath(@__DIR__,"src/assets/themes/documenter-dark.css"))

makedocs(
  format = Documenter.HTML(
    assets=["assets/favicon.ico", asset("https://fonts.googleapis.com/css?family=Montserrat|Source+Code+Pro&display=swap", class=:css)],
    prettyurls = istravis,
    mathengine = KaTeX(Dict(
      :macros => Dict(
        "\\x" => "\\boldsymbol{x}",
        "\\z" => "\\boldsymbol{z}",
        "\\l" => "\\boldsymbol{l}",
        "\\c" => "\\boldsymbol{c}",
        "\\C" => "\\boldsymbol{C}",
        "\\g" => "\\boldsymbol{g}",
        "\\G" => "\\boldsymbol{G}",
        "\\f" => "\\boldsymbol{f}",
        "\\F" => "\\boldsymbol{F}",
        "\\R" => "\\mathbb{R}",
        "\\1" => "\\mathbb{1}"
      )
    ))
  ),
  sitename = "GeoStats.jl",
  authors = "Júlio Hoffimann",
  pages = [
    "Home" => "index.md",
    "Basic workflow" => "workflow.md",
    "Tutorials" => "tutorials.md",
    "Reference guide" => [
      "Data" => "data.md",
      "Domains" => "domains.md",
      "Operations" => [
        "operations/partitioning.md",
        "operations/weighting.md",
        "operations/sampling.md",
        "operations/filtering.md",
        "operations/joining.md",
        "operations/searching.md",
        "operations/covering.md",
        "operations/discretizing.md"
      ],
      "Statistics" => "statistics.md",
      "Problems" => "problems.md",
      "Solvers" => "solvers.md",
      "Validation" => "validation.md",
      "Variography" => [
        "variography/empirical.md",
        "variography/theoretical.md",
        "variography/fitting.md"
      ],
      "Kriging" => [
        "kriging/estimators.md",
        "kriging/solver.md"
      ],
      "Point Patterns" => [
        "pointpatterns/pointprocs.md",
        "pointpatterns/regions.md",
        "pointpatterns/pointops.md"
      ],
      "Plotting" => "plotting.md"
    ],
    "Developer guide" => [
      "The basics" => "devguide/basics.md",
      "Solver examples" => "devguide/examples.md"
    ],
    "Contributing" => "contributing.md",
    "Related projects" => "related.md",
    "About" => [
      "Community" => "about/community.md",
      "License" => "about/license.md",
      "Citing" => "about/citing.md"
    ],
    "Index" => "links.md"
  ]
)

deploydocs(repo="github.com/JuliaEarth/GeoStats.jl.git")
