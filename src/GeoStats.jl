# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

module GeoStats

using Reexport
using Random
using LinearAlgebra
using Distributed
using StaticArrays

# reexport basic packages
@reexport using Distances
@reexport using Distributions

# reexport project modules
@reexport using GeoStatsBase
@reexport using KrigingEstimators

# extend base module
import GeoStatsBase: solve, solve_single, preprocess

# solvers installed by default
include("solvers/kriging.jl")
include("solvers/seqsim.jl")
include("solvers/sgsim.jl")
include("solvers/cookiecutter.jl")

export
  # solvers
  Kriging,
  SeqGaussSim,
  CookieCutter

end # module
