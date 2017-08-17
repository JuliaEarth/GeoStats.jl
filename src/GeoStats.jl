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

__precompile__(true)

module GeoStats

using DataFrames
using Combinatorics: combinations
using SpecialFunctions: besselk
using Parameters: @with_kw
using RecipesBase

# utilities and datatypes
include("utils.jl")
include("geodataframe.jl")

# geostatistical concepts
include("distances.jl")
include("empirical_variograms.jl")
include("theoretical_variograms.jl")
include("estimators.jl")

# geostatistical problems
include("domains.jl")
include("paths.jl")
include("problems.jl")
include("solvers.jl")
include("solutions.jl")

# plot recipes
include("plotrecipes/empirical_variograms.jl")
include("plotrecipes/theoretical_variograms.jl")
include("plotrecipes/problems/estimation_problem.jl")

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

  # estimators
  SimpleKriging,
  OrdinaryKriging,
  UniversalKriging,
  ExternalDriftKriging,
  fit!,
  weights,
  estimate,

  # domains
  RegularGrid,
  PointCollection,
  coordtype,
  npoints,
  coordinates,

  # data types
  GeoDataFrame,
  data,
  coordnames,
  coordinates,
  npoints,
  readtable,

  # problems and solutions
  EstimationProblem,
  SimulationProblem,
  data,
  domain,
  variables,
  hasdata,
  nreals,
  digest,

  # solvers
  Kriging, KrigParam,
  SeqGaussSim, SGSParam,
  solve

end
