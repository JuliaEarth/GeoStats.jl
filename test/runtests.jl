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

# target location
xₒ = rand(dim)

# list of tests
testfiles = [
  "distances.jl",
  "empirical_variograms.jl",
  "theoretical_variograms.jl",
  "estimators.jl",
  "geodataframe.jl",
  "domains.jl"
]

# run
for testfile in testfiles
  include(testfile)
end
