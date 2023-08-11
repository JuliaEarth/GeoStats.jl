# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module GeoStatsMakieExt

using GeoStats

using Tables
using Makie: cgrad
using Makie.Colors: Colorant

import Makie
import Meshes: ascolors, defaultscheme
import GeoStats: hscatter, hscatter!
import GeoStats: varioplot, varioplot!
import GeoStats: viewer

# color handling
include("colors.jl")

# geostats recipes
include("histogram.jl")
include("variogram.jl")
include("hscatter.jl")

# scientific viewer
include("viewer.jl")

end