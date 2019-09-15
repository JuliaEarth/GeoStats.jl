using GeoStats
using Test, Pkg, Random

# list of tests
testfiles = [
]

@testset "GeoStats.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
