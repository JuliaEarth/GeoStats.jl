# ------------------------------------------------------------------
# Copyright (c) 2015, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

__precompile__()

module GeoStats

using Reexport
using Distances
using StatsBase: sample
using Distributions
using Combinatorics: multiexponents
using SpecialFunctions: besselk
using RecipesBase

# won't be needed in Julia v0.7
using Parameters: @with_kw
@reexport using NamedTuples

# export project modules
@reexport using GeoStatsBase
@reexport using GeoStatsDevTools

# extend base module
import GeoStatsBase: digest, solve, solve_single

# utilities
include("distances.jl")
include("distributions.jl")

# variograms and Kriging estimators
include("empirical_variograms.jl")
include("theoretical_variograms.jl")
include("estimators.jl")

# solvers
include("solvers.jl")

# digest solutions
include("solutions/estimation_solution.jl")
include("solutions/simulation_solution.jl")

# solver comparisons
include("comparisons.jl")

# plot recipes
include("plotrecipes/hscatter.jl")
include("plotrecipes/empirical_variograms.jl")
include("plotrecipes/theoretical_variograms.jl")
include("plotrecipes/solutions/estimation_solution.jl")
include("plotrecipes/solutions/simulation_solution.jl")

# helper function to launch examples from Julia prompt
function examples()
  path = joinpath(@__DIR__,"..","examples")
  @eval using IJulia
  @eval notebook(dir=$path)
end

export
  # distances
  Ellipsoidal,
  evaluate,

  # distributions
  EmpiricalDistribution,
  quantile,
  cdf,

  # empirical variograms
  EmpiricalVariogram,

  # theoretical variograms
  GaussianVariogram,
  ExponentialVariogram,
  MaternVariogram,
  SphericalVariogram,
  CubicVariogram,
  PentasphericalVariogram,
  PowerVariogram,
  SineHoleVariogram,
  CompositeVariogram,
  isstationary,

  # Kriging estimators
  SimpleKriging,
  OrdinaryKriging,
  UniversalKriging,
  ExternalDriftKriging,
  fit!,
  weights,
  estimate,

  # solvers
  Kriging,
  SeqGaussSim,

  # solver comparisons
  VisualComparison,
  CrossValidation,
  compare

end # module
