# Workaround for GR warnings
ENV["GKSwstype"] = "100"

using Documenter, GeoStats
using DocumenterTools: Themes

istravis = "TRAVIS" ∈ keys(ENV)

Themes.compile(joinpath(@__DIR__,"src/assets/geostats-light.scss"), joinpath(@__DIR__,"src/assets/themes/documenter-light.css"))
Themes.compile(joinpath(@__DIR__,"src/assets/geostats-light.scss"), joinpath(@__DIR__,"src/assets/themes/documenter-dark.css"))

makedocs(
  format = Documenter.HTML(
    assets=[asset("https://fonts.googleapis.com/css?family=Montserrat|Source+Code+Pro&display=swap", class=:css)],
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
      "Operations" => "operations.md",
      "Statistics" => "statistics.md",
      "Problems" => "problems.md",
      "Solvers" => "solvers.md",
      "Validation" => "validation.md",
      "Variography" => [
        "empvario.md",
        "theovario.md",
        "fitvario.md"
      ],
      "Point Patterns" => [
        "pointprocs.md",
        "regions.md",
        "pointops.md"
      ],
      "Kriging" => [
        "krigestim.md",
        "krigsolver.md"
      ],
      "Plotting" => "plotting.md"
    ],
    "Developer guide" => [
      "The basics" => "devbasics.md",
      "Solver examples" => "devexamples.md"
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
