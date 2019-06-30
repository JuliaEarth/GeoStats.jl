# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

module GeoStats

using Reexport

# reexport basic packages
@reexport using Distances
@reexport using Distributions

# reexport project modules
@reexport using GeoStatsBase
@reexport using Variography
@reexport using KrigingEstimators

end
