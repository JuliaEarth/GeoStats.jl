# Workaround for GR warnings
ENV["GKSwstype"] = "100"

using Documenter, GeoStats

istravis = "TRAVIS" ∈ keys(ENV)

makedocs(
  format = Documenter.HTML(assets=["assets/style.css"], prettyurls=istravis),
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
    "About" => [
      "Community" => "about/community.md",
      "License" => "about/license.md",
      "Citing" => "about/citing.md"
    ],
    "Index" => "links.md"
  ]
)

deploydocs(repo="github.com/juliohm/GeoStats.jl.git")
