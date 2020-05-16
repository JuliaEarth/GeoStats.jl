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

Z = [10sin(i/10) + j for i in 1:100, j in 1:200]

Ω = RegularGridData{Float64}(OrderedDict(:Z=>Z))

hscatter(sample(Ω, 500), :Z, lags=[0.,20.,50.])
```

## varplane

A variogram plane (i.e. `varplane`) plot is a visualization that displays a collection of directional
variograms for all angles in a given plane for 2D or 3D spatial data.

```julia
# horizontal plane ==> theta=0, phi=90
varplane(Ω, :Z, theta=0, phi=90)
```
![](images/VarPlane.png)
