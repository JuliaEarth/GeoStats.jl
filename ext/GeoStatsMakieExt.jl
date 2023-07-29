# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module GeoStatsMakieExt

using GeoStats

import GeoStats: hscatter, hscatter!
import GeoStats: varioplot, varioplot!
import Makie

# geostats recipes
include("histogram.jl")
include("variogram.jl")
include("hscatter.jl")

end