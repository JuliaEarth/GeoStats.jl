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

# create some data
dim = 3; nobs = 10
X = rand(dim, nobs)
z = rand(nobs)

# some target location
xₒ = rand(dim)

# load some geodataframes
fname1D = joinpath(datadir,"data1D.tsv")
data1D = readtable(fname1D, coordnames=[:x])
fname2D = joinpath(datadir,"data2D.tsv")
data2D = readtable(fname2D, coordnames=[:x,:y])
fname3D = joinpath(datadir,"data3D.tsv")
data3D = readtable(fname3D)

# list of tests
testfiles = [
  "utils.jl",
  "empirical_variograms.jl",
  "theoretical_variograms.jl",
  "estimators.jl",
  "geodataframe.jl",
  "domains.jl",
  "paths.jl",
  "neighborhoods.jl",
  "mappers.jl",
  "problems.jl",
  "solvers.jl",
  "comparisons.jl"
]

# run
for testfile in testfiles
  include(testfile)
end
