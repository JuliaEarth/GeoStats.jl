## Copyright (c) 2015, Júlio Hoffimann Mendes <juliohm@stanford.edu>
##
## Permission to use, copy, modify, and/or distribute this software for any
## purpose with or without fee is hereby granted, provided that the above
## copyright notice and this permission notice appear in all copies.
##
## THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
## WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
## ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
## WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
## ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
## OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

__precompile__()

module GeoStats

using Reexport
using DataFrames: AbstractDataFrame, eltypes, nrow, completecases!, sample
import DataFrames
using Combinatorics: combinations
using SpecialFunctions: besselk
using RecipesBase

# extend base package
@reexport using GeoStatsBase
import GeoStatsBase: coordinates, variables, npoints, valid, domain, digest, solve

# won't be needed in Julia v0.7
using Parameters: @with_kw
@reexport using NamedTuples

# utilities
include("utils.jl")

# spatial data
include("spatialdata/geodataframe.jl")

# domains
include("domains/regular_grid.jl")
include("domains/point_collection.jl")

# variograms and Kriging estimators
include("distances.jl")
include("empirical_variograms.jl")
include("theoretical_variograms.jl")
include("estimators.jl")

# geometrical concepts
include("paths.jl")
include("neighborhoods.jl")
include("mappers.jl")

# problems
include("problems/estimation_problem.jl")
include("problems/simulation_problem.jl")

# solutions
include("solutions/estimation_solution.jl")
include("solutions/simulation_solution.jl")

# solvers
include("solvers.jl")

# plot recipes
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
  # distance functions
  EuclideanDistance,
  EllipsoidDistance,
  HaversineDistance,

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

  # spatial data
  GeoDataFrame,
  readtable,

  # domains
  RegularGrid,
  PointCollection,
  origin,
  spacing,

  # solvers
  Kriging,
  SeqGaussSim

end
