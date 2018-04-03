using GeoStats
using GeoStatsImages
using Plots; gr(size=(600,400))
using Base.Test
using VisualRegressionTests

# test project modules
for pkg in ["GeoStatsBase","GeoStatsDevTools",
            "Variography","KrigingEstimators"]
  Pkg.test(pkg)
end

# setup GR backend for Travis CI
ENV["GKSwstype"] = "100"
ENV["PLOTS_TEST"] = "true"

# list of maintainers
maintainers = ["juliohm"]

# environment settings
istravis = "TRAVIS" ∈ keys(ENV)
ismaintainer = "USER" ∈ keys(ENV) && ENV["USER"] ∈ maintainers
datadir = joinpath(@__DIR__,"data")

# very simple data
fname1D = joinpath(datadir,"data1D.tsv")
data1D = readtable(fname1D, delim='\t', coordnames=[:x])
fname2D = joinpath(datadir,"data2D.tsv")
data2D = readtable(fname2D, delim='\t', coordnames=[:x,:y])
fname3D = joinpath(datadir,"data3D.tsv")
data3D = readtable(fname3D, delim='\t')

# missing data and NaN
fname = joinpath(datadir,"missing.tsv")
missdata = readtable(fname, delim='\t', coordnames=[:x,:y])

# more realistic data
fname = joinpath(datadir,"samples2D.tsv")
samples2D = readtable(fname, delim='\t', coordnames=[:x,:y])

# list of tests
testfiles = [
  "distances.jl",
  "distributions.jl",
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
