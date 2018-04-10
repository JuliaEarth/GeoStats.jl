# ------------------------------------------------------------------
# Copyright (c) 2015, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

__precompile__()

module GeoStats

using Reexport
using Distances
using StatsBase: sample
using RecipesBase

# won't be needed in Julia v0.7
@reexport using NamedTuples

# export project modules
@reexport using GeoStatsBase
@reexport using GeoStatsDevTools
@reexport using KrigingEstimators

# extend base module
import GeoStatsBase: solve, solve_single

# solvers installed by default
include("solvers/kriging.jl")
include("solvers/sgsim.jl")

# solver comparisons
include("comparisons/cross_validation.jl")
include("comparisons/visual_comparison.jl")

# plot recipes
include("plotrecipes/hscatter.jl")
include("plotrecipes/solutions/estimation_solution.jl")
include("plotrecipes/solutions/simulation_solution.jl")

# helper function to launch examples from Julia prompt
function examples()
  path = joinpath(@__DIR__,"..","examples")
  @eval using IJulia
  @eval notebook(dir=$path)
end

export
  # solvers
  Kriging,
  SeqGaussSim,

  # solver comparisons
  VisualComparison,
  CrossValidation

end # module
