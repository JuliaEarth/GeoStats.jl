# Plotting

Most objects defined in the project can be plotted directly without major efforts.
Other plots are provided below that can be useful for spatial data analysis.

## hscatter

A hscatter plot between two variables `var1` and `var2` (possibly with `var2` =
`var1`) is a simple scatter plot in which the dots represent all ordered pairs of
values of `var1` and `var2` at a given lag `h`.

```@example plots
using GeoStats
using Plots
gr(size=(800,300)) # hide

𝒟 = georef((Z=[10sin(i/10) + j for i in 1:100, j in 1:200],))

hscatter(sample(𝒟, 500), :Z, lags=[0.,20.,50.])
```
