# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module GeoStats

using Reexport

# reexport project modules
@reexport using GeoStatsBase
@reexport using Variography
@reexport using KrigingEstimators
@reexport using PointPatterns
@reexport using GeoEstimation
@reexport using GaussianSimulation

end
