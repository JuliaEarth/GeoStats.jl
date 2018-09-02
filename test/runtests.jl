using GeoStats
using Plots; gr(size=(600,400))
using VisualRegressionTests
using Test, Pkg, Random

# list of maintainers
maintainers = ["juliohm"]

# environment settings
istravis = "TRAVIS" ∈ keys(ENV)
ismaintainer = "USER" ∈ keys(ENV) && ENV["USER"] ∈ maintainers
datadir = joinpath(@__DIR__,"data")

if ismaintainer
  Pkg.add("Gtk")
  using Gtk
end

# load data sets
data1D = readgeotable(joinpath(datadir,"data1D.tsv"), delim='\t', coordnames=[:x])
data2D = readgeotable(joinpath(datadir,"data2D.tsv"), delim='\t', coordnames=[:x,:y])

# list of tests
testfiles = [
  "solvers.jl",
  "comparisons.jl"
]

@testset "GeoStats.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
