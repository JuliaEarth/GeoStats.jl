# Workaround for GR warnings
ENV["GKSwstype"] = "100"

using Documenter, GeoStats
using DocumenterTools: Themes

istravis = "TRAVIS" ∈ keys(ENV)

Themes.compile(joinpath(@__DIR__,"src/assets/geostats-light.scss"), joinpath(@__DIR__,"src/assets/themes/documenter-light.css"))
Themes.compile(joinpath(@__DIR__,"src/assets/geostats-light.scss"), joinpath(@__DIR__,"src/assets/themes/documenter-dark.css"))

makedocs(
  format = Documenter.HTML(assets=[
    asset("https://fonts.googleapis.com/css?family=Montserrat|Source+Code+Pro&display=swap", class=:css)
  ], prettyurls=istravis),
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
      "Kriging" => "kriging.md",
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
