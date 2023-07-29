# Plotting

```@example plots
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats # hide
import WGLMakie as Mke # hide
```

Most objects defined in GeoStats.jl can be plotted directly with
[Makie.jl](https://github.com/MakieOrg/Makie.jl).  Additional plots
are listed below that can be useful for geostatistical analysis.

## Built-in

A `hscatter` plot between two variables `var1` and `var2` (possibly
with `var2` = `var1`) is a simple scatter plot in which the dots
represent all ordered pairs of values of `var1` and `var2` at a
given lag `h`.

```@example plots
𝒟 = georef((Z=[10sin(i/10) + j for i in 1:100, j in 1:200],))

𝒮 = sample(𝒟, 500)

fig = Mke.Figure(resolution = (800, 400))
hscatter(fig[1,1], 𝒮, :Z, :Z, lag=0)
hscatter(fig[1,2], 𝒮, :Z, :Z, lag=20)
hscatter(fig[2,1], 𝒮, :Z, :Z, lag=40)
hscatter(fig[2,2], 𝒮, :Z, :Z, lag=60)
fig
```

## PairPlots.jl

The [PairPlots.jl](https://github.com/sefffal/PairPlots.jl) package
provides the `corner` plot that can be used with any table, including
tables of attributes obtained with the [`values`](@ref) function.

## AlgebraOfGraphics.jl

The [AlgebraOfGraphics.jl](https://github.com/MakieOrg/AlgebraOfGraphics.jl)
package provides various statistical plots with a syntax that is similar to
R's [ggplot](https://ggplot2.tidyverse.org) package. Check their official
[gallery](https://aog.makie.org/stable/gallery) for examples.
