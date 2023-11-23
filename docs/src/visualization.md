# Visualization

```@example plots
using GeoStats # hide
import CairoMakie as Mke # hide
```

The framework provides powerful visualization recipes for
geospatial data science via the [Makie.jl](https://github.com/MakieOrg/Makie.jl)
project. These recipes were carefully designed to maximize productivity
and to protect users from GIS jargon. The main entry point is the
[`viz`](@ref) function:

```@docs
viz
viz!
```

This function takes a geospatial domain as input and provides a set of
aesthetic options to style the elements (i.e. geometries) of the domain.

!!! note

    Notice that the geometry column of our geospatial data type is a domain
    (i.e. `data.geometry isa Domain`), and that this design enables several
    optimizations in the visualization itself.

Users can also call Makie's `plot` function in the geometry column as in

```julia
Mke.plot(data.geometry)
```

and this is equivalent to calling the [`viz`](@ref) recipe above. The `plot`
function also works with various other objects such as [`EmpiricalHistogram`](@ref)
and [`EmpiricalVariogram`](@ref). That is convenient if you don't remember
the name of the recipe.

Additionaly, we provide a basic scientific [`viewer`](@ref) to visualize
all viewable variables in the data:

```@docs
viewer
```

Other plots are listed below that can be useful for geostatistical analysis.

## Built-in

A `hscatter` plot between two variables `var1` and `var2` (possibly
with `var2` = `var1`) is a simple scatter plot in which the dots
represent all ordered pairs of values of `var1` and `var2` at a
given lag `h`.

```@example plots
𝒟 = georef((Z=[10sin(i/10) + j for i in 1:100, j in 1:200],))

𝒮 = sample(𝒟, UniformSampling(500))

fig = Mke.Figure(size = (800, 400))
hscatter(fig[1,1], 𝒮, :Z, :Z, lag=0)
hscatter(fig[1,2], 𝒮, :Z, :Z, lag=20)
hscatter(fig[2,1], 𝒮, :Z, :Z, lag=40)
hscatter(fig[2,2], 𝒮, :Z, :Z, lag=60)
fig
```

## PairPlots.jl

The [PairPlots.jl](https://github.com/sefffal/PairPlots.jl) package
provides the `pairplot` function that can be used with any table, including
tables of attributes obtained with the [`values`](@ref) function.

## AlgebraOfGraphics.jl

The [AlgebraOfGraphics.jl](https://github.com/MakieOrg/AlgebraOfGraphics.jl)
package provides various statistical plots with a syntax that is similar to
R's [ggplot](https://ggplot2.tidyverse.org) package. Check their official
[gallery](https://aog.makie.org/stable/gallery) for examples.
