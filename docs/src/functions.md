# Overview

```@example functions
using GeoStats # hide
import CairoMakie as Mke # hide
```

Geostatistical functions describe geospatial association of samples
based on their locations. These functions have different properties,
which are relevant for specific applications, and are documented in
the [Variograms](variograms.md), [Covariances](covariances.md) and
[Transiograms](transiograms.md) sections.

Below we list the general properties of all geostatistical functions
as well as utilities to properly plot, composite and fit these functions
to empirical estimates. We illustrate these concepts with variograms
given their wide use.

## Properties

The following properties can be checked about a geostatistical function:

```@docs
isstationary(::GeoStatsFunction)
isisotropic(::GeoStatsFunction)
issymmetric(::GeoStatsFunction)
isbanded(::GeoStatsFunction)
metricball(::GeoStatsFunction)
range(::GeoStatsFunction)
nvariates(::GeoStatsFunction)
```

## Anisotropy

Anisotropic functions can be constructed from a list of `ranges` and `rotation`
matrix from [Rotations.jl](https://github.com/JuliaGeometry/Rotations.jl):

```@example functions
γ = GaussianVariogram(ranges = (3.0, 2.0, 1.0), rotation = RotZXZ(0.0, 0.0, 0.0))
```

Rotation angles from commercial geostatistical software are also provided:

```@docs
MinesightAngles
DatamineAngles
VulcanAngles
GslibAngles
```

The effect of anisotropy is clear in the evaluation of the function on any
pair of points or geometries:

```@example functions
γ(Point(0, 0, 0), Point(1, 0, 0))
```

```@example functions
γ(Point(0, 0, 0), Point(0, 1, 0))
```

```@example functions
γ(Point(0, 0, 0), Point(0, 0, 1))
```

In the case of isotropic functions, all the results coincide, and one can
also use the single argument evaluation with a lag in length units:

```@example functions
γ = GaussianVariogram(range=3.0)
```

```@example functions
γ(1)
```

Below we illustrate the concept of anisotropy with different rotation angles:

```@example functions
using Random # hide
Random.seed!(2000) # hide

points = rand(Point, 50, crs=Cartesian2D) |> Scale(100)
geotable = georef((Z=rand(50),), points)

viz(geotable.geometry, color = geotable.Z)
```

```@example functions
θs = range(0.0, step = π/4, stop = 2π - π/4)

# initialize figure
fig = Mke.Figure(size = (800, 1600))

# helper function to position subfigures
pos = i -> CartesianIndices((4, 2))[i].I

# domain of interpolation
grid = CartesianGrid(100, 100)

# anisotropic variogram with different rotation angles
for (i, θ) in enumerate(θs)
  # anisotropic variogram model
  γ = GaussianVariogram(ranges = (20.0, 5.0), rotation = Angle2d(θ))

  # perform interpolation
  interp = geotable |> Interpolate(grid, model=Kriging(γ))

  # visualize solution at subplot i
  viz(fig[pos(i)...],
    interp.geometry, color = interp.Z,
    axis = (title = "θ = $(rad2deg(θ))ᵒ",)
  )
end

fig
```

## Plotting

The function [`funplot`](@ref)/[`funplot!`](@ref) can be used to plot
any geostatistical function:

```@docs
funplot
funplot!
```

Consider the following example with an anisotropic Gaussian variogram:

```@example functions
γ = GaussianVariogram(ranges=(3, 2, 1))
```

```@example functions
funplot(γ)
```

The function [`surfplot`](@ref)/[`surfplot!`](@ref) can be used to plot
surfaces of association given a normal direction:

```@docs
surfplot
surfplot!
```

```@example functions
surfplot(γ)
```

## Compositing

Composite functions of the form
``f(h) = c_1\cdot f_1(h) + c_2\cdot f_2(h) + \cdots + c_n\cdot f_n(h)``
can be constructed using matrix coefficients ``c_1, c_2, \ldots, c_n``.
The individual structures can be recovered in canonical form with the
[`structures`](@ref) utility:

```@docs
structures
```

```@example functions
γ₁ = GaussianVariogram(nugget=1, sill=2)
γ₂ = ExponentialVariogram(nugget=2, sill=3)

# composite model with matrix coefficients
γ = [1.0 0.0; 0.0 1.0] * γ₁ + [2.0 0.5; 0.5 3.0] * γ₂

# structures in canonical form
cₒ, c, g = structures(γ)

cₒ # matrix nugget
```

```@example functions
c # matrix coefficients
```

```@example functions
g # normalized structures
```

## Fitting

Fitting theoretical functions to empirical functions is an important
modeling step to ensure valid mathematical models of geospatial continuity:

```@docs
GeoStatsFunctions.fit
```

Consider the following empirical variogram as an example:

```@example functions
# sinusoidal data
𝒟 = georef((Z=[sin(i/2) + sin(j/2) for i in 1:50, j in 1:50],))

# empirical variogram
g = EmpiricalVariogram(𝒟, :Z, maxlag = 25u"m")

funplot(g)
```

We can fit a specific theoretical variogram such as the
[`SphericalVariogram`](@ref) with

```@example functions
γ = GeoStatsFunctions.fit(SineHoleVariogram, g)

fig = funplot(g)
funplot!(fig, γ, maxlag = 25u"m")
```

or we can let the framework find the theoretical
variogram with minimum error:

```@example functions
γ = GeoStatsFunctions.fit(Variogram, g)

fig = funplot(g)
funplot!(fig, γ, maxlag = 25u"m")
```

The [`SineHoleVariogram`](@ref) fits the empirical variogram
well given that this is a sinusoidal field.

Optionally, we can specify a weighting function to give different
weights to the lags:

```@example functions
γ = GeoStatsFunctions.fit(SineHoleVariogram, g, h -> 1 / h^2)

fig = funplot(g)
funplot!(fig, γ, maxlag = 25u"m")
```

The following fitting methods are available:

```@docs
WeightedLeastSquares
```
