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

# plots via Makie extension
include("plots.jl")

# reexport project modules
@reexport using Meshes
@reexport using Chain: @chain
@reexport using Distances: Euclidean, Haversine
@reexport using Rotations: Angle2d, AngleAxis, RotXYZ
@reexport using LossFunctions: L2DistLoss, L1DistLoss
@reexport using LossFunctions: HingeLoss, MisclassLoss
@reexport using DensityRatioEstimation
@reexport using ScientificTypes
@reexport using TableTransforms
@reexport using GeoStatsBase
@reexport using Variography
@reexport using KrigingEstimators
@reexport using PointPatterns
@reexport using GeoClustering
@reexport using GeoStatsSolvers

end
