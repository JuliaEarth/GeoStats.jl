# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module GeoStatsMakieExt

using GeoStats

using Tables
using Makie.Colors: Colorant
using Makie.Colors: protanopic, coloralpha
using Makie.Colors: distinguishable_colors
using Makie.ColorSchemes: colorschemes

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