# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module GeoStatsMakieExt

using GeoStats

import Makie
import GeoStats: hscatter, hscatter!
import GeoStats: varioplot, varioplot!

# geostats recipes
include("histogram.jl")
include("variogram.jl")
include("hscatter.jl")

end
