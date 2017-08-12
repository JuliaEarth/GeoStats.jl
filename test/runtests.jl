using GeoStats
using GeoStatsImages
using Plots; gr(size=(600,400))
using Base.Test
using VisualRegressionTests

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

# load some geodataframes
fname = joinpath(datadir,"data2D.tsv")
data2D = readtable(fname, coordnames=[:x,:y])
fname = joinpath(datadir,"data3D.tsv")
data3D = readtable(fname)

# some target location
xₒ = rand(dim)

# list of tests
testfiles = [
  "distances.jl",
  "empirical_variograms.jl",
  "theoretical_variograms.jl",
  "estimators.jl",
  "geodataframe.jl",
  "domains.jl",
  "paths.jl",
  "problems.jl",
  "solvers.jl",
  "show.jl"
]

# run
for testfile in testfiles
  include(testfile)
end
