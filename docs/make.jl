using Documenter, GeoStats
using DocumenterTools: Themes

using Random: AbstractRNG

# transforms api
using TransformsBase

# external solvers
using ImageQuilting
using TuringPatterns
using StratiGraphics

# IO packages
using GeoIO

istravis = "TRAVIS" ∈ keys(ENV)

Themes.compile(joinpath(@__DIR__,"src/assets/light.scss"), joinpath(@__DIR__,"src/assets/themes/documenter-light.css"))
Themes.compile(joinpath(@__DIR__,"src/assets/dark.scss"), joinpath(@__DIR__,"src/assets/themes/documenter-dark.css"))

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
    "Quickstart" => "quickstart.md",
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
      "Geospatial transforms" => "transforms.md",
      "Geospatial queries" => "queries.md",
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
      "Visualization" => "visualization.md"
    ],
    "Contributing" => [
      "contributing/guidelines.md",
      "contributing/solvers.md"
    ],
    "Resources" => [
      "resources/education.md",
      "resources/publications.md",
      "resources/ecosystem.md"
    ],
    "About" => [
      "Community" => "about/community.md",
      "License" => "about/license.md",
      "Citing" => "about/citing.md"
    ],
    "Index" => "links.md"
  ]
)

repo = "github.com/JuliaEarth/GeoStatsDocs.git"

withenv("GITHUB_REPOSITORY" => repo) do
  deploydocs(repo=repo)
end
