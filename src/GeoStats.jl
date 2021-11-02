# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module GeoStats

using Reexport

# reexport related stack
@reexport using Distances: Euclidean, Chebyshev, Haversine 
@reexport using LossFunctions: L2DistLoss, L1DistLoss
@reexport using LossFunctions: HingeLoss, MisclassLoss
@reexport using DensityRatioEstimation
@reexport using ScientificTypes
@reexport using TableTransforms
@reexport using Meshes

# reexport project modules
@reexport using GeoStatsBase
@reexport using Variography
@reexport using KrigingEstimators
@reexport using PointPatterns
@reexport using GeoClustering
@reexport using GeoEstimation
@reexport using GeoSimulation
@reexport using GeoLearning

end
