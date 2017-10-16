using Documenter, GeoStats

# manually handle dependencies until
# Documenter.jl issue #534 is solved
Pkg.installed("Plots") == nothing && Pkg.add("Plots")
Pkg.installed("GR") == nothing && Pkg.add("GR")

# setup GR backend for Travis CI
ENV["GKSwstype"] = "100"

makedocs(
  format = :html,
  sitename = "GeoStats.jl",
  authors = "Júlio Hoffimann Mendes",
  pages = [
    "Home" => "index.md",
    "Manual" => [
      "Problems and solvers" => "problems_and_solvers.md",
      "Spatial data" => "spatialdata.md",
      "Domains" => "domains.md",
      "Variograms" => [
        "empirical_variograms.md",
        "theoretical_variograms.md"
      ],
      "Kriging estimators" => "estimators.md",
      "Distance functions"  => "distances.md"
    ],
    "Examples" => "examples.md",
    "Plotting" => "plotting.md",
    "Library" => "library.md",
    "Contributing" => "contributing.md",
    "About" => [
      "Author" => "about/author.md",
      "License" => "about/license.md"
    ]
  ]
)

deploydocs(
  repo  = "github.com/juliohm/GeoStats.jl.git",
  target = "build",
  deps = nothing,
  make = nothing,
  julia = "0.6"
)
