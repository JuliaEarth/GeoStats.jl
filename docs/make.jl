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
    "User guide" => "userguide.md",
    "Tutorials" => "tutorials.md",
    "Reference guide" => [
      "Data" => "data.md",
      "Domains" => "domains.md",
      "Problems" => "problems.md",
      "Variography" => [
        "empirical_variograms.md",
        "theoretical_variograms.md",
        "fitting_variograms.md"
      ],
      "Kriging estimators" => "estimators.md",
      "Solver comparisons" => "comparisons.md",
      "Spatial operations" => "operations.md",
      "Plotting" => "plotting.md"
    ],
    "Developer guide" => "devguide.md",
    "Contributing" => "contributing.md",
    "Related packages" => "related.md",
    "About" => [
      "Community" => "about/community.md",
      "License" => "about/license.md",
      "Citing" => "about/citing.md"
    ],
    "Index" => "links.md"
  ]
)

deploydocs(repo="github.com/JuliaEarth/GeoStats.jl.git")
