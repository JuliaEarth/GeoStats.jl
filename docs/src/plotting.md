# Plotting

Most objects defined in the project can be plotted directly without major efforts.
Other plots are provided below that can be useful for spatial data analysis.

## hscatter

A `hscatter` plot between two variables `var1` and `var2` (possibly with `var2` =
`var1`) is a simple scatter plot in which the dots represent all ordered pairs of
values of `var1` and `var2` at a given lag `h`.

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

## distplot1d

A `distplot1d` of a variable `var` displays the adjusted spatial histogram
(see [`EmpiricalHistogram`](@ref)), and optionally a list of quantiles.

```@example plots
z = randn(500)

𝒮 = georef((Z=z,))

distplot1d(𝒮, :Z, quantiles=[0.25,0.50,0.75])
```

## distplot2d

A `distplot2d` of two variables `var1` and `var2` displays the 2D histogram,
and optionally a list of quantiles.

```@example plots
z1 = randn(500)
z2 = z1 + randn(500)

𝒮 = georef((Z1=z1, Z2=z2))

distplot2d(𝒮, :Z1, :Z2, quantiles=[0.25,0.50,0.75])
```

## cornerplot

A `cornerplot` displays a grid of plots with `distplot1d` plots in the diagonal
and `distplot2d` in the off-diagonal entries of the grid.

```@example plots
z1 = randn(500)
z2 = z1 + randn(500)

𝒮 = georef((Z1=z1, Z2=z2))

cornerplot(𝒮, (:Z1,:Z2), quantiles=[0.25,0.50,0.75])
```
