# Quickstart

A geostatistical workflow often consists of three steps:

1. Manipulation of geospatial data
2. Definition of geostatistical problem
3. Visualization of problem solution

In this section, we walk through these steps to illustrate some of the
features of the project. Although we use [Plots.jl](https://github.com/JuliaPlots/Plots.jl)
and the [GeoStatsPlots.jl](https://github.com/JuliaEarth/GeoStatsPlots.jl) recipes for
visualization, we could have used [Makie.jl](https://github.com/JuliaPlots/Makie.jl)
and [GeoStatsViz.jl](https://github.com/JuliaEarth/GeoStatsViz.jl) recipes for more
advanced [3D visualization examples](https://github.com/JuliaGeometry/MeshViz.jl).

```@example quickstart
using GeoStats
using Plots, GeoStatsPlots
gr(format=:png,size=(800,400),aspectratio=:equal) # hide
```

## Manipulating data

The workflow starts with the creation of geospatial data, which can
be loaded from disk or derived from other Julia variables. For example,
given a Julia array (or image), which is not attached to any particular
coordinate system:

```@example quickstart
Z = [10sin(i/10) + j for i in 1:100, j in 1:200]

heatmap(Z)
```

We can georeference the array using the [`georef`](@ref) function:

```@example quickstart
Ω = georef((Z=Z,))
```

The origin and spacing of samples can be specified with:

```@example quickstart
georef((Z=Z,), origin=(1.,1.), spacing=(10.,10.))
```

and different geospatial configurations can be obtained with different
methods (see [Data](data.md)).

We plot the geospatial data and note a few differences compared to the
plot shown above:

```@example quickstart
plot(Ω)
```

First, we note that the image was rotated to match the first index `i`
of the array with the horizontal `x` axis, and the second index `j` of
the array with the vertical `y` axis. Second, we note that the image
was stretched to reflect the real `100x200` size of the `CartesianGrid`.

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
domain with [`domain`](@ref):

```@example quickstart
values(Ω)
```

```@example quickstart
domain(Ω)
```

and this can be useful for writing algorithms that depend purely on
the geometry or purely on the feature values.

### Table transforms

It is easy to design advanced geospatial pipelines that operate on
both the table of attributes and the underlying geospatial domain:

```@example quickstart
# pipeline with table transforms
pipe = Quantile()

# feed geospatial data to pipeline
Ω̄ = Ω |> pipe

# plot distribution before and after pipeline
p1 = histogram(Ω.Z, color=:gray80, label="original")
p2 = histogram(Ω̄.Z, color=:gray80, label="quantile")
plot(p1, p2, layout=(2,1))
```

These pipelines are revertible meaning that one can transform the data,
perform geostatistical modeling, and revert the pipelines to obtain
estimates in the original sample space (see [Transforms](transforms.md)).

### Split-apply-combine

We provide three macros [`@groupby`](@ref), [`@transform`](@ref) and
[`@combine`](@ref) for powerful geospatial split-apply-combine patterns:

```@example quickstart
@transform(Ω, :W = 2 * :Z * area(:geometry))
```

These macros are very useful for geodata science as they hide the
complexity of the `geometry` column. For more information, check
the [Split-apply-combine](splitapplycombine.md) section of the
documentation.

### Geospatial views

Geospatial data can be viewed at a subset of locations without
unnecessary memory allocations:

```@example quickstart
Ωᵥ = view(Ω, 1:10*100)

plot(Ωᵥ)
```

We plot a random view of the grid to emphasize that views do not
preserve geospatial regularity:

```@example quickstart
inds = rand(1:100*200, 100)

plot(view(Ω, inds))
```

### Geospatial partitions

Geospatial data can be partitioned with various efficient methods.
To demonstrate the operation, we partition our geospatial data view
into balls of given radius:

```@example quickstart
Π = partition(Ωᵥ, BallPartition(5.))

plot(Π)
```

or, alternatively, into two halfspaces:

```@example quickstart
Π = partition(Ωᵥ, BisectFractionPartition((1.,1.), 0.5))

plot(Π)
```

Geospatial partitions are (lazy) iterators of geospatial views, which
are useful in many contexts as it will be shown in the next section.
To access a subset of a partition, we use index notation:

```@example quickstart
plot(Π[1])
```

```@example quickstart
plot(Π[2])
```

Various other geospatial operations are defined in the framework besides
partitioning. For a complete list, please check the reference guide and
the [Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl) documentation.

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
Ω = georef(table, (:x,:y))

plot(Ω, (:band4,:crop), ms=0.2, mc=:viridis)
```

Similar to a generic statistical learning workflow, we split the data
into "train" and "test" sets. The main difference here is that our
geospatial `split` function accepts a separating plane specified by
its normal direction `(1,-1)`:

```@example quickstart
Ωs, Ωt = split(Ω, 0.2, (1.,-1.))

plot(domain(Ωs), ms=0.2, mc=:royalblue)
plot!(domain(Ωt), ms=0.2, mc=:gray)
```

We can visualize the domain of the "train" (or source) set Ωs in blue,
and the domain of the "test" (or target) set Ωt in gray. We reserved
20% of the samples to Ωs and 80% to Ωt. Internally, this geospatial
`split` function is implemented in terms of efficient geospatial
partitions, which were illustrated in the previous section.

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
with more than 150 classical learning models:

```@example quickstart
using MLJ

ℳ = MLJ.@load DecisionTreeClassifier pkg=DecisionTree

ℒ = PointwiseLearn(ℳ())
```

In this example, we selected a `PointwiseLearn` strategy to solve the
geostatistical learning problem. This strategy consists of applying the
learning model pointwise for every location in the geospatial data:

```@example quickstart
Ω̂t = solve(𝒫, ℒ)
```

## Plotting solutions

We note that the solution to a geostatistical learning problem is a
geospatial data object, and we can inspect it with the same methods
already described above. This also means that we can plot the solution
directly, side by side with the true label in this synthetic example:

```@example quickstart
p̂ = plot(Ω̂t, ms=0.2, mc=:viridis, title="crop (prediction)")
p = plot(Ωt, (:crop,), ms=0.2, mc=:viridis)

plot(p̂, p)
```

Visually, it seems that the learning model is predicting the crop type.
We can also estimate the generalization error of the geostatistical solver
with [geostatistical validation methods](validation.md) such as block
cross-validation and leave-ball-out, but these methods deserve
a separate tutorial.

With this example we conclude the basic workflow. To get familiar with
other features of the project, please check the tutorials and the
reference guide.
