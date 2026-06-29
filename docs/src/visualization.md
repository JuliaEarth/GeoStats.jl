# Visualization

```@example plots
using GeoStats # hide
import CairoMakie as Mke # hide
```

## Scientific visualization

The framework is integrated with the powerful
[Makie.jl](https://github.com/MakieOrg/Makie.jl)
ecosystem. The recipes documented below assume
that a Makie backend is loaded in the same session.

```@docs
viz
viz!
viewer
cbar
```

The [`viz`](@ref) and [`viz!`](@ref) recipes take a
geospatial domain or a vector of geometries as input.
The [`viewer`](@ref) takes a geotable as input and calls
[`viz`](@ref) on all columns that can be converted to
colors by the [Colorfy.jl](https://github.com/JuliaGraphics/Colorfy.jl)
package. It also adds a color bar [`cbar`](@ref) with
the same color scheme.

## Statistical plots

### Built-in

```@docs
hscatter
```

```@example plots
gtb = georef((z=[10sin(i/10) + j for i in 1:100, j in 1:200],)) |>
      Sample(500, replace=false)

fig = Mke.Figure(size = (800, 800))
hscatter(fig[1,1], gtb, "z", "z", lag=0)
hscatter(fig[1,2], gtb, "z", "z", lag=20)
hscatter(fig[2,1], gtb, "z", "z", lag=40)
hscatter(fig[2,2], gtb, "z", "z", lag=60)
fig
```

### Other plots

The plots below can be very useful to explore the
distribution of [`values`](@ref) in a geotable:

- [PairPlots.jl](https://github.com/sefffal/PairPlots.jl)
provides the `pairplot` function to explore multivariate
continuous distributions.

- [AlgebraOfGraphics.jl](https://github.com/MakieOrg/AlgebraOfGraphics.jl)
is a very flexible alternative that supports grouped and
faceted layouts based on categorical variables.

- [Biplots.jl](https://github.com/MakieOrg/Biplots.jl)
provides 2D and 3D statistical biplots for identifying
main axes of variation.
