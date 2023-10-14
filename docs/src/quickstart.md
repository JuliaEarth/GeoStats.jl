# Quickstart

```@example quickstart
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide
```

A geostatistical workflow often consists of four steps:

1. Creation of geospatial data
2. Manipulation of geospatial data
3. Definition of geostatistical problem
4. Visualization of problem solution

In this section, we walk through these steps to illustrate some of the
features of the project. If you prefer learning from video, check out
the recording of our JuliaEO2023 workshop:

```@raw html
<p align="center">
<iframe style="width:560px;height:315px" src="https://www.youtube.com/embed/1FfgjW5XQ9g?start=1682" title="GeoStats.jl workshop at JuliaEO2023" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
</p>
```

We assume that the following packages are loaded throughout the code examples:

```@example quickstart
using GeoStats
import WGLMakie as Mke
```

The **GeoStats.jl** package exports the full stack for geospatial data science
and geostatistical modeling. The **WGLMakie.jl** package is one of the possible
visualization backends from the [Makie.jl](https://docs.makie.org/stable)
project.

If you are new to Julia and have never heard of **Makie.jl** before, here are a
few tips to help you choose between the different backends:

- **WGLMakie.jl** is the preferred backend for interactive visualization on the
  *web browser*. It integrates well with [Pluto.jl](https://plutojl.org) notebooks
  and other web-based applications.

- **GLMakie.jl** is the preferred backend for interactive *high-performance*
  visualization. It leverages native graphical resources and doesn't require
  a web browser to function.

- **CairoMakie.jl** is the preferred backend for *publication-quality* static
  visualization. It requires less computing power and is therefore recommended
  for those users with modest laptops.

!!! note

    We recommend importing the Makie.jl backend as `Mke` to avoid polluting the
    Julia session with names from the visualization stack.

## Loading/creating data

### Loading data

The Julia ecosystem for loading geospatial data is comprised of several
low-level packages such as [Shapefile.jl](https://github.com/JuliaGeo/Shapefile.jl)
and [GeoJSON.jl](https://github.com/JuliaGeo/GeoJSON.jl), which define
their own very basic geometry types. Instead of requesting users to learn
the so called [GeoInterface.jl](https://github.com/JuliaGeo/GeoInterface.jl)
to handle these types, we provide the high-level
[GeoIO.jl](https://github.com/JuliaEarth/GeoIO.jl) package to
load any file with geospatial data into well-tested geometries from the
[Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl) submodule:

```@example quickstart
using GeoIO

zone = GeoIO.load("data/zone.shp")
path = GeoIO.load("data/path.shp")

viz(zone.geometry)
viz!(path.geometry, color = :gray90)
Mke.current_figure()
```

Various functions are defined over these geometries, for instance:

```@example quickstart
sum(area, zone.geometry)
```

```@example quickstart
sum(perimeter, zone.geometry)
```

Please check the [Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl)
documentation for more details.

!!! note

    We **highly recommend** using Meshes.jl geometries in geospatial workflows as
    they were carefully designed to accomodate advanced features of the GeoStats.jl
    framework. Any other geometry type will likely fail with our geostatistical
    algorithms and pipelines.

### Creating data

Geospatial data can be derived from other Julia variables. For example,
given a Julia array, which is not attached to any coordinate system, we
can georeference the array using the [`georef`](@ref) function:

```@example quickstart
Z = [10sin(i/10) + 2j for i in 1:50, j in 1:50]

Ω = georef((Z=Z,))
```

Default coordinates are assigned based on the size of the array, and different
configurations can be obtained with different methods (see [Data](data.md)).

Geospatial data can be visualized with the [`viz`](@ref) recipe function:

```@example quickstart
viz(Ω.geometry, color = Ω.Z)
```

Alternatively, we provide a basic scientific [`viewer`](@ref) to visualize
all viewable variables in the data with a colorbar and other interactive
elements (see [Visualization](visualization.md)):

```@example quickstart
viewer(Ω)
```

!!! note

    Julia supports unicode symbols with $\LaTeX$ syntax. We can type `\Omega`
    and press `TAB` to get the symbol `Ω` in the example above.
    This autocompletion works in various text editors, including the
    [VSCode](https://code.visualstudio.com/docs/languages/julia) editor with
    the Julia extension.

## Manipulating data

### Table interface

Our geospatial data implements the
[Tables.jl](https://github.com/JuliaData/Tables.jl) interface, which
means that they can be accessed as if they were tables with samples
in the rows and variables in the columns. In this case, a special
column named `geometry` is created on the fly, row by row, containing
[Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl) geometries.

For those familiar with the productive
[DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) interface,
there is nothing new:

```@example quickstart
Ω[1,:]
```

```@example quickstart
Ω[1,:geometry]
```

```@example quickstart
Ω.Z
```

However, notice that our implementation performs some clever
optimizations behind the scenes to avoid expensive creation
of geometries:

```@example quickstart
Ω.geometry
```

We can always retrieve the table of attributes (or features)
with the function [`values`](@ref) and the underlying geospatial
domain with the function [`domain`](@ref). This can be useful for
writing algorithms that are *type-stable* and depend purely on the
feature values:

```@example quickstart
values(Ω)
```

or on the geometries:

```@example quickstart
domain(Ω)
```

### Geospatial transforms

It is easy to design advanced geospatial pipelines that operate on
both the table of features and the underlying geospatial domain:

```@example quickstart
# pipeline with table transforms
pipe = Quantile() → StdCoords()

# feed geospatial data to pipeline
Ω̂ = pipe(Ω)

# plot distribution before and after pipeline
fig = Mke.Figure(resolution = (800, 400))
Mke.hist(fig[1,1], Ω.Z, color = :gray)
Mke.hist(fig[2,1], Ω̂.Z, color = :gray)
fig
```

Coordinates before pipeline:

```@example quickstart
boundingbox(Ω.geometry)
```

and after pipeline:

```@example quickstart
boundingbox(Ω̂.geometry)
```

These pipelines are revertible meaning that we can transform the data,
perform geostatistical modeling, and revert the pipelines to obtain
estimates in the original sample space (see [Transforms](transforms.md)).

### Geospatial queries

We provide three macros [`@groupby`](@ref), [`@transform`](@ref) and
[`@combine`](@ref) for powerful geospatial split-apply-combine patterns,
as well as the function [`geojoin`](@ref) for advanced geospatial joins.

```@example quickstart
@transform(Ω, :W = 2 * :Z * area(:geometry))
```

These are very useful for geospatial data science as they hide the complexity
of the `geometry` column. For more information, check the [Queries](queries.md)
section of the documentation.

## Defining problems

Having defined the geospatial data objects, we proceed and define the
geostatistical problem to be solved. In this guide, we illustrate
*geostatistical learning*. For other types of geostatistical problems,
please check the [Problems](problems.md) section of the documentation.

Let's assume that we have geopatial data with some variable that we want
to predict in a supervised learning setting. We load the data from a CSV
file, and inspect the available columns:

```@example quickstart
using CSV

csv = CSV.File("data/agriculture.csv")
```

Columns `band1`, `band2`, ..., `band4` represent four satellite bands
for different locations `(x,y)` in this region. The column `crop` has
the crop type for each location that was labeled manually with the
purpose of training a learning model. Because the labels are categorical
variables, we need to inform the framework the correct scientific type from
[ScientificTypes.jl](https://github.com/JuliaAI/ScientificTypes.jl):

```@example quickstart
table = csv |> Coerce(:crop => Multiclass)

first(table.crop, 5)
```

We can now georeference the table and plot some of the variables:

```@example quickstart
Ω = georef(table, (:x, :y))

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], Ω.geometry, color = Ω.band4, pointsize = 2)
viz(fig[1,2], Ω.geometry, color = Ω.crop, pointsize = 2)
fig
```

Similar to a generic statistical learning workflow, we split the data
into "train" and "test" sets. The main difference here is that our
geospatial `geosplit` function accepts a separating plane specified by
its normal direction `(1,-1)`:

```@example quickstart
Ωs, Ωt = geosplit(Ω, 0.2, (1.0, -1.0))

viz(Ωs.geometry, pointsize = 2)
viz!(Ωt.geometry, color = :gray90, pointsize = 2)
Mke.current_figure()
```

We can visualize the domain of the "train" (or source) set Ωs in blue,
and the domain of the "test" (or target) set Ωt in gray. We reserved
20% of the samples to Ωs and 80% to Ωt. Internally, this geospatial
`geosplit` function is implemented in terms of efficient geospatial
partitions.

Let's define the learning task and the geostatistical learning problem.
We want to predict the crop type based on the four satellite bands.
We will train the model in Ωs where labels are available, and apply it
to Ωt, which is our target:

```@example quickstart
feats = [:band1,:band2,:band3,:band4]
label = :crop

𝒯 = ClassificationTask(feats, label)

𝒫 = LearningProblem(Ωs, Ωt, 𝒯)
```

GeoStats.jl is integrated with the
[MLJ.jl](https://github.com/alan-turing-institute/MLJ.jl)
project, which means that we can solve geostatistical learning problems
with more than 200 classical learning models, including all models
from [ScitkitLearn.jl](https://github.com/cstjean/ScikitLearn.jl):

```@example quickstart
using MLJ

ℳ = MLJ.@load DecisionTreeClassifier pkg=DecisionTree

ℒ = PointwiseLearn(ℳ())
```

In this example, we selected a [`PointwiseLearn`](@ref) strategy to solve
the geostatistical learning problem. This strategy consists of applying
the learning model pointwise for every location in the geospatial data:

```@example quickstart
Ω̂t = solve(𝒫, ℒ)
```

## Visualizing solutions

We note that the solution to a geostatistical learning problem is a
geospatial data object, and we can inspect it with the same methods
already described above. This also means that we can visualize the
solution directly, side by side with the true label in this synthetic
example:

```@example quickstart
fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], Ω̂t.geometry, color = Ω̂t.crop, pointsize = 2)
viz(fig[1,2], Ωt.geometry, color = Ωt.crop, pointsize = 2)
fig
```

Visually, it seems that the learning model is predicting the crop type.
We can also estimate the generalization error of the geostatistical solver
with [geostatistical validation methods](validation.md) such as block
cross-validation and leave-ball-out, but these methods deserve
a separate tutorial.

With this example we conclude the basic workflow. To get familiar with
other features of the project, please check the the reference guide.
