# User guide

This guide provides an overview of a simple geostatistical workflow, which consists of
of three basic steps:

1. Manipulation of spatial data
2. Definition of geostatistical problem
3. Visualization of problem solution

These steps are only shown to guide the reader, which is free to follow his/her own workflow.

## Manipulating data

The workflow starts with the creation of spatial data objects, which can be loaded from
disk or derived from other Julia variables. For example, given a Julia array (or image),
which is not attached to any particular coordinate system:

```@example userguide
using Plots
gr(format=:svg) # hide

Z = [10sin(i/10) + j for i in 1:100, j in 1:200]

heatmap(Z, c=:bluesreds)
```

we can georeference the image as [RegularGridData](@ref):

```@example userguide
using GeoStats

Ω = RegularGridData{Float64}(Dict(:Z=>Z))
```

The origin and spacing of samples in the regular grid can be specified in the constructor:

```@example userguide
RegularGridData(Dict(:Z=>Z), (1.,1.), (10.,10.))
```

and different spatial data types have different constructor options (see [Data](data.md) for more options).

We plot the spatial data and note a few differences compared to the image plot shown above:

```@example userguide
plot(Ω)
```

First, we note that the image was rotated to match the first index `i` of the array
with the horizontal "x" axis, and the second index `j` of the array with the vertical
"y" axis. Second, we note that the image was stretched to reflect the real `100x200`
size of the regular grid data.

Each sample in the spatial data object has a coordinate, which is calculated on demand
for a given list of locations (i.e. spatial indices):

```@example userguide
coordinates(Ω, 1:3)
```

In-place versions exist to avoid unnecessary memory allocations.

All coordinates are retrieved as a `ndims x npoints` matrix when we do not specify
the spatial indices:

```@example userguide
coordinates(Ω)
```

### Tabular access

Spatial data types implement the [Tables.jl](https://github.com/JuliaData/Tables.jl)
interface, which means that they can be accessed as if they were tables with samples
in the rows and variables in the columns:

```@example userguide
Ω[1:3,:Z]
```

In this case, the coordinates of the samples are lost. To reconstruct a spatial data
object, we need to save the spatial indices that were used to index the table:

```@example userguide
zvals = Ω[1:3,:Z]
coord = coordinates(Ω, 1:3)

PointSetData(Dict(:Z=>zvals), coord)
```

To recover the original Julia array behind a spatial data object, we can index the
data with the variable name. In this case, the size of the array (i.e. `100x200`)
is preserved:

```@example userguide
Ω[:Z]
```

### Spatial views

Spatial data types can be viewed at a subset of locations without unnecessary
memory allocations. Spatial views do not preserve the spatial regularity of the
data in general.

By plotting a view of the first 10 lines of our regular grid data, we obtain a
general [PointSetData](@ref) as opposed to a [RegularGridData](@ref):

```@example userguide
Ωᵥ = view(Ω, 1:10*100)
plot(Ωᵥ)
```

We plot a random view of the grid to emphasize that views do not preserve
spatial regularity:

```@example userguide
inds = rand(1:npoints(Ω), 100)
plot(view(Ω, inds))
```

### Data partitions

Spatial data objects can be partitioned with various efficient methods.
To demonstrate the operation, we partition our spatial data view into
balls of given radius:

```@example userguide
Π = partition(Ωᵥ, BallPartitioner(5.))
plot(Π)
```

or, alternatively, into two halfspaces:

```@example userguide
Π = partition(Ωᵥ, BisectFractionPartitioner((1.,1.), 0.5))
plot(Π)
```

Spatial partitions are (lazy) iterators of spatial views, which are useful in
many contexts as it will be shown in the next section of the user guide. To
access a subset of a partition, we use index notation:

```@example userguide
plot(Π[1])
```

```@example userguide
plot(Π[2])
```

## Defining problems

Having defined the spatial data objects, we proceed and define the geostatistical
problem to be solved. In this guide, we illustrate *geostatistical learning*. For
other types of geostatistical problems, please check the [Problems](problems.md)
section of the documentation.

Let's assume that we have spatial data with some variable that we want to predict
in a supervised learning setting. We load the data from a CSV file, and inspect
the available columns:

```@example userguide
using CSV

df = CSV.read("data/agriculture.csv")

first(df, 5)
```

Columns `band1`, ..., `band4` represent four satellite bands for different
locations `(x,y)` in this spatial region. The column `crop` has the crop type
for each location that was labeled manually with the purpose of training a
learning model.

Because the labels are categorical variables, we need to inform the framework
the correct categorical type:

```@example userguide
using CategoricalArrays

df.crop = categorical(df.crop)

first(df, 5)
```

We can now georeference the data as a [GeoDataFrame](@ref) and plot some of
the spatial variables:

```@example userguide
Ω = GeoDataFrame(df, [:x,:y])

gr(format=:png) # hide
plot(Ω, variables=[:band4,:crop], ms=0.5, mc=:viridis, size=(800,400))
```

Similar to a generic statistical learning workflow, we split the data into "train"
and "test" sets. The main difference here is that our spatial `split` function
accepts a separating plane specified by its normal direction `(1,-1)`:

```@example userguide
Ωs, Ωt = split(Ω, 0.2, (1.,-1.))

plot(domain(Ωs), ms=0.5)
plot!(domain(Ωt), ms=0.5, mc=:green)
```

We can visualize the domain of the "train" (or source) set Ωs in black, and the
domain of the "test" (or target) set Ωt in green. We reserved 20% of the samples
to Ωs and 80% to Ωt.

Let's define the learning task and the geostatistical learning problem. We want
to predict the crop type based on the four satellite bands. We will train the model
in Ωs where labels are available, and apply it to Ωt, which is our target:

```@example userguide
features = [:band1,:band2,:band3,:band4]
label    = :crop

task = ClassificationTask(features, label)

problem = LearningProblem(Ωs, Ωt, task)
```

GeoStats.jl is integrated with the [MLJ.jl](https://github.com/alan-turing-institute/MLJ.jl)
project, which means that we can solve geostatistical learning problems with any classical
learning model:

```@example userguide
using MLJ

@load DecisionTreeClassifier

model = DecisionTreeClassifier()

solver = PointwiseLearn(model)
```

In this example, we selected a `PointwiseLearn` strategy to solve the geostatistical
learning problem. This strategy consists of applying the learning model pointwise for
every point in the spatial data:

```@example userguide
Ω̂t = solve(problem, solver)
```

## Plotting solutions

First, we note that the solution to a geostatistical learning problem is a spatial
data object. We can inspect it with the same methods already described:

```@example userguide
Ω̂t[1:5,:crop]
```

This also means that we can plot the solution directly, side by side with the
true label in this synthetic example:

```@example userguide
p̂ = plot(Ω̂t, ms=0.5, mc=:viridis, title="crop (prediction)")
p = plot(Ωt, variables=[:crop], ms=0.5, mc=:viridis)

plot(p̂, p, size=(800,400))
```

Visually, the learning model has succeeded predicting the crop. We can also
estimate the generalization error of the geostatistical solver with spatial
validation methods such as block cross-validation and leave-ball-out, but
these methods deserve a separate tutorial.

With this example we conclude the user guide. To get familiar with other
features of GeoStats.jl, please check the [Tutorials](@ref) and the
[Reference guide](@ref).
