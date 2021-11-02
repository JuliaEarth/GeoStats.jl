# Plotting

Most objects defined in the project can be plotted directly without
major efforts. Other plots are provided below that can be useful for
geospatial data analysis.

## hscatter

A `hscatter` plot between two variables `var1` and `var2` (possibly
with `var2` = `var1`) is a simple scatter plot in which the dots
represent all ordered pairs of values of `var1` and `var2` at a
given lag `h`.

```@example plots
using GeoStats
using Plots
gr(size=(800,300)) # hide

𝒟 = georef((Z=[10sin(i/10) + j for i in 1:100, j in 1:200],))

𝒮 = sample(𝒟, 500)

p1 = hscatter(𝒮, :Z, lag=0)
p2 = hscatter(𝒮, :Z, lag=20)
p3 = hscatter(𝒮, :Z, lag=40)
p4 = hscatter(𝒮, :Z, lag=60)

plot(p1, p2, p3, p4)
```

## corner

The [PairPlots.jl](https://github.com/sefffal/PairPlots.jl) package
provides the `corner` plot that can be used with any table, including
tables of attributes obtained with the [`values`](@ref) function.