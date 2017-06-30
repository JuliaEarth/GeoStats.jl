using GeoStats
using Base.Test

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
  "variograms.jl",
  "estimators.jl"
]

# run
for testfile in testfiles
  include(testfile)
end
