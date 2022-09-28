# Workaround for GR warnings
ENV["GKSwstype"] = "100"

using Documenter, GeoStats
using DocumenterTools: Themes

using Random: AbstractRNG

# external solvers
using ImageQuilting
using TuringPatterns
using StratiGraphics

istravis = "TRAVIS" ∈ keys(ENV)

Themes.compile(joinpath(@__DIR__,"src/assets/geostats-light.scss"), joinpath(@__DIR__,"src/assets/themes/documenter-light.css"))
Themes.compile(joinpath(@__DIR__,"src/assets/geostats-dark.scss"), joinpath(@__DIR__,"src/assets/themes/documenter-dark.css"))

makedocs(
  format = Documenter.HTML(
    assets=["assets/favicon.ico", asset("https://fonts.googleapis.com/css?family=Montserrat|Source+Code+Pro&display=swap", class=:css)],
    prettyurls = istravis,
    mathengine = KaTeX(Dict(
      :macros => Dict(
        "\\cov" => "\\text{cov}",
        "\\x"   => "\\boldsymbol{x}",
        "\\z"   => "\\boldsymbol{z}",
        "\\l"   => "\\boldsymbol{\\lambda}",
        "\\c"   => "\\boldsymbol{c}",
        "\\C"   => "\\boldsymbol{C}",
        "\\g"   => "\\boldsymbol{g}",
        "\\G"   => "\\boldsymbol{G}",
        "\\f"   => "\\boldsymbol{f}",
        "\\F"   => "\\boldsymbol{F}",
        "\\R"   => "\\mathbb{R}",
        "\\1"   => "\\mathbb{1}"
      )
    ))
  ),
  sitename = "GeoStats.jl",
  authors = "Júlio Hoffimann",
  pages = [
    "Home" => "index.md",
    "Basic workflow" => "workflow.md",
    "Reference guide" => [
      "Data" => "data.md",
      "Domains" => "domains.md",
      "Problems" => "problems.md",
      "Solvers" => [
        "solvers/overview.md",
        "solvers/builtin.md",
        "solvers/external.md"
      ],
      "Validation" => "validation.md",
      "Clustering" => "clustering.md",
      "Declustering" => "declustering.md",
      "Transforms" => "transforms.md",
      "Variography" => [
        "variography/empirical.md",
        "variography/theoretical.md",
        "variography/fitting.md"
      ],
      "Kriging" => "kriging.md",
      "Point patterns" => [
        "pointpatterns/pointprocs.md",
        "pointpatterns/pointops.md"
      ],
      "Ensembles" => "ensembles.md",
      "Weighting" => "weighting.md",
      "Miscellaneous" => "miscellaneous.md",
      "Plotting" => "plotting.md"
    ],
    "Contributing" => [
      "contributing/guidelines.md",
      "Developer guide" => [
        "contributing/solvers.md"
      ]
    ],
    "Resources" => [
      "resources/education.md",
      "resources/publications.md",
      "resources/ecosystem.md",
      "resources/glossary.md"
    ],
    "About" => [
      "Community" => "about/community.md",
      "License" => "about/license.md",
      "Citing" => "about/citing.md"
    ],
    "Index" => "links.md"
  ]
)

deploydocs(repo="github.com/JuliaEarth/GeoStats.jl.git")
