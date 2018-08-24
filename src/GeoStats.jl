# ------------------------------------------------------------------
# Copyright (c) 2015, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

module GeoStats

using Reexport
using Random
using Distances
using Distributed
using LinearAlgebra
using StatsBase: sample
using StaticArrays
using RecipesBase

# export project modules
@reexport using GeoStatsBase
@reexport using GeoStatsDevTools
@reexport using KrigingEstimators

# extend base module
import GeoStatsBase: solve, solve_single, preprocess

# solvers installed by default
include("solvers/kriging.jl")
include("solvers/sgsim.jl")
include("solvers/cookiecutter.jl")

# solver comparisons
include("comparisons/cross_validation.jl")
include("comparisons/visual_comparison.jl")

export
  # solvers
  Kriging,
  SeqGaussSim,
  CookieCutter,

  # solver comparisons
  VisualComparison,
  CrossValidation

end # module
