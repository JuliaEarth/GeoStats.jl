using Documenter, GeoStats

makedocs(
  format = :html,
  sitename = "GeoStats.jl",
  authors = "Júlio Hoffimann Mendes",
  pages = [
    "Home" => "index.md",
    "Manual" => [
      "Variograms" => [
        "empirical_variograms.md",
        "theoretical_variograms.md"
      ],
      "Kriging estimation" => "estimation.md",
      "Distance functions"  => "distances.md"
    ],
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
