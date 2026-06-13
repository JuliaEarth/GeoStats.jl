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
```

Users can also call Makie's `plot` function in the geometry column as in

```julia
Mke.plot(data.geometry)
```

and this is equivalent to calling the [`viz`](@ref) recipe above. The `plot`
function also works with other objects such as [`EmpiricalHistogram`](@ref).
That is convenient if you don't remember the name of the recipe.

Additionaly, we provide a basic scientific [`viewer`](@ref) to visualize
all viewable variables in the data:

```@docs
viewer
cbar
```

## Statistical plots

### Built-in

A `hscatter` plot between two variables `var1` and `var2` (possibly
with `var2` = `var1`) is a simple scatter plot in which the dots
represent all ordered pairs of values of `var1` and `var2` at a
given lag `h`.

```@example plots
data = georef((Z=[10sin(i/10) + j for i in 1:100, j in 1:200],))

samp = sample(data, UniformSampling(500))

fig = Mke.Figure(size = (800, 800))
hscatter(fig[1,1], samp, "Z", "Z", lag=0)
hscatter(fig[1,2], samp, "Z", "Z", lag=20)
hscatter(fig[2,1], samp, "Z", "Z", lag=40)
hscatter(fig[2,2], samp, "Z", "Z", lag=60)
fig
```

### Other plots

The plots below can be very useful to explore the
distribution of [`values`](@ref) in a geotable.

[PairPlots.jl](https://github.com/sefffal/PairPlots.jl)
provides the `pairplot` function to explore multivariate
continuous distributions.

[AlgebraOfGraphics.jl](https://github.com/MakieOrg/AlgebraOfGraphics.jl)
is a very flexible alternative that supports grouped and
faceted layouts based on categorical variables.

[Biplots.jl](https://github.com/MakieOrg/Biplots.jl)
provides 2D and 3D statistical biplots for identifying
main axes of variation.
