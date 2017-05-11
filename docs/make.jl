using Documenter, GeoStats

makedocs(
  format = :html,
  sitename = "GeoStats.jl",
  authors = "Júlio Hoffimann Mendes",
  pages = [
    "Home" => "index.md",
    "Estimation" => "estimation.md",
    "Variograms" => "variograms.md",
    "Library" => "library.md"
  ]
)

deploydocs(
  repo  = "github.com/juliohm/GeoStats.jl.git",
  target = "build",
  deps = nothing,
  make = nothing,
  julia = "0.5"
)
