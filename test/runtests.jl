using GeoStats
using GeoStatsImages
using Plots; gr(size=(600,400))
using Base.Test
using VisualRegressionTests

# setup GR backend for Travis CI
ENV["GKSwstype"] = "100"

# list of maintainers
maintainers = ["juliohm"]

# environment settings
istravis = "TRAVIS" ∈ keys(ENV)
ismaintainer = "USER" ∈ keys(ENV) && ENV["USER"] ∈ maintainers
datadir = joinpath(@__DIR__,"data")

# floating point tolerance
tol = 10eps()

# very simple data
fname1D = joinpath(datadir,"data1D.tsv")
data1D = readtable(fname1D, delim='\t', coordnames=[:x])
fname2D = joinpath(datadir,"data2D.tsv")
data2D = readtable(fname2D, delim='\t', coordnames=[:x,:y])
fname3D = joinpath(datadir,"data3D.tsv")
data3D = readtable(fname3D, delim='\t')

# more realistic data
fname = joinpath(datadir,"samples2D.tsv")
samples2D = readtable(fname, delim='\t', coordnames=[:x,:y])

# list of tests
testfiles = [
  "distances.jl",
  "distributions.jl",
  "empirical_variograms.jl",
  "theoretical_variograms.jl",
  "estimators.jl",
  "spatialdata.jl",
  "domains.jl",
  "paths.jl",
  "neighborhoods.jl",
  "mappers.jl",
  "problems.jl",
  "solvers.jl",
  "comparisons.jl",
  "plotrecipes.jl"
]

@testset "GeoStats.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
