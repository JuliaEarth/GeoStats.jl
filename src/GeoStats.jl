# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module GeoStats

using Reexport

# reexport project modules
@reexport using Meshes
@reexport using GeoStatsBase
@reexport using Variography
@reexport using KrigingEstimators
@reexport using PointPatterns
@reexport using GeoClustering
@reexport using GeoEstimation
@reexport using GeoSimulation
@reexport using GeoLearning

end
