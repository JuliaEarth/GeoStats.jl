# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module GeoStats

# use README.md as the module docs
@doc let
  path = joinpath(dirname(@__DIR__), "README.md")
  include_dependency(path)
  text = read(path, String)
  first(split(text, "##"))
end GeoStats

using Reexport

# reexport project modules
@reexport using CoDa
@reexport using Dates
@reexport using Unitful
@reexport using Meshes
@reexport using GeoTables
@reexport using Distances
@reexport using Rotations
@reexport using Statistics
@reexport using Distributions
@reexport using LossFunctions
@reexport using CategoricalArrays
@reexport using DensityRatioEstimation
@reexport using DataScienceTraits
@reexport using TableTransforms
@reexport using StatsLearnModels
@reexport using GeoStatsBase
@reexport using Variography
@reexport using GeoStatsModels
@reexport using GeoStatsProcesses
@reexport using GeoStatsTransforms
@reexport using GeoStatsSolvers
@reexport using Chain: @chain

end
