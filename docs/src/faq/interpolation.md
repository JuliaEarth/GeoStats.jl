# Why Kriging interpolation is slow?

```@example interpfaq
using GeoStats # hide
import CairoMakie as Mke # hide
```

You are probably using the [`Interpolate`](@ref) when
you should be using the [`InterpolateNeighbors`](@ref).

The [`Kriging`](@ref) model relies on the construction of
a $N \times N$ matrix where $N$ is the number of rows of
the input `GeoTable`. The `Interpolate` transform will
attempt to build the full linear system, which cannot
be feasible. On the other hands, the `InterpolateNeighbors`
transform constructs local linear systems with a maximum
number of neighbors. It scales to very large datasets.

## Exact interpolation

The `Interpolate` transform is exact, and hence it is recommended if the
number of rows of the geotable is small:

```@example interpfaq
gtb = georef((; z=[1.,0.,1.]), [(25.,25.), (50.,75.), (75.,50.)])

grid = CartesianGrid(100, 100)

model = Kriging(GaussianVariogram(range=35.))

interp = gtb |> Interpolate(grid, model=model)

interp |> viewer
```

## Approximate interpolation

The `InterpolateNeighbors` transform is approximate. The choice of
parameters determines the quality of the result. Poor choices can
lead to visual artifacts:

```@example interpfaq
interp = gtb |> InterpolateNeighbors(grid, model=model, maxneighbors=2)

interp |> viewer
```
