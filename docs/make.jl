# Workaround for JuliaLang/julia/pull/28625
if Base.HOME_PROJECT[] !== nothing
  Base.HOME_PROJECT[] = abspath(Base.HOME_PROJECT[])
end

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
    "User guide" => [
      "Problems & solvers" => "problems_and_solvers.md",
      "Spatial data" => "spatialdata.md",
      "Domains" => "domains.md",
      "Variography" => [
        "empirical_variograms.md",
        "theoretical_variograms.md",
        "fitting_variograms.md"
      ],
      "Kriging estimators" => "estimators.md",
      "Solver comparisons" => "comparisons.md",
      "Spatial statistics" => "statistics.md",
      "Plotting" => "plotting.md"
    ],
    "Tutorials" => "tutorials.md",
    "Contributing" => "contributing.md",
    "About" => [
      "Community" => "about/community.md",
      "License" => "about/license.md",
      "Citing" => "about/citing.md"
    ],
    "Developer guide" => "developers.md",
    "Index" => "links.md"
  ]
)

deploydocs(repo="github.com/juliohm/GeoStats.jl.git")
