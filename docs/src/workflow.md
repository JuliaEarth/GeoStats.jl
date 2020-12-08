# Basic workflow

A basic geostatistical workflow often consists of three steps:

1. Manipulation of spatial data
2. Definition of geostatistical problem
3. Visualization of problem solution

In this section, we walk through these steps to illustrate some of the features
of the project.

## Manipulating data

The workflow starts with the creation of spatial data objects, which can be loaded
from disk or derived from other Julia variables. For example, given a Julia array
(or image), which is not attached to any particular coordinate system:

```@example workflow
using Plots
gr(format=:svg) # hide

Z = [10sin(i/10) + j for i in 1:100, j in 1:200]

heatmap(Z)
```

We can georeference the image using the [`georef`](@ref) function:

```@example workflow
using GeoStats

Ω = georef((Z=Z,))
```

The origin and spacing of samples in the image can be specified with:

```@example workflow
georef((Z=Z,), origin=(1.,1.), spacing=(10.,10.))
```

and different spatial configurations can be obtained with different methods (see [Data](data.md)).

We plot the spatial data and note a few differences compared to the image plot shown above:

```@example workflow
plot(Ω)
```

First, we note that the image was rotated to match the first index `i` of the array
with the horizontal "x" axis, and the second index `j` of the array with the vertical
"y" axis. Second, we note that the image was stretched to reflect the real `100x200`
size of the regular grid data.

Each sample in the spatial data object has a coordinate, which is calculated on demand
for a given list of locations (i.e. spatial indices):

```@example workflow
coordinates(Ω, 1:3)
```

In-place versions exist to avoid unnecessary memory allocations.

All coordinates are retrieved as a matrix when we do not specify the spatial indices:

```@example workflow
coordinates(Ω)
```

### Tabular access

Spatial data types implement the [Tables.jl](https://github.com/JuliaData/Tables.jl)
interface, which means that they can be accessed as if they were tables with samples
in the rows and variables in the columns. This interface is convenient to pass spatial
data to non-spatial workflows directly.

Additionaly, we can access the values of a variable as a vector using the variable name:

```@example workflow
Ω[:Z]
```

### Spatial views

Spatial data types can be viewed at a subset of locations without unnecessary
memory allocations. Spatial views do not preserve the spatial regularity of the
data in general.

By plotting a view of the first 10 lines of our image data, we obtain a
general point set as opposed to a regular grid configuration:

```@example workflow
Ωᵥ = view(Ω, 1:10*100)
plot(Ωᵥ)
```

We plot a random view of the grid to emphasize that views do not preserve
spatial regularity:

```@example workflow
inds = rand(1:nelms(Ω), 100)
plot(view(Ω, inds))
```

### Data partitions

Spatial data objects can be partitioned with various efficient methods.
To demonstrate the operation, we partition our spatial data view into
balls of given radius:

```@example workflow
Π = partition(Ωᵥ, BallPartition(5.))
plot(Π)
```

or, alternatively, into two halfspaces:

```@example workflow
Π = partition(Ωᵥ, BisectFractionPartition((1.,1.), 0.5))
plot(Π)
```

Spatial partitions are (lazy) iterators of spatial views, which are useful in
many contexts as it will be shown in the next section. To access a subset of
a partition, we use index notation:

```@example workflow
plot(Π[1])
```

```@example workflow
plot(Π[2])
```

Various other spatial operations are defined in the framework besides partitioning.
For a complete list, please check the [Operations](operations/partitioning.md)
section of the reference guide.

## Defining problems

Having defined the spatial data objects, we proceed and define the geostatistical
problem to be solved. In this guide, we illustrate *geostatistical learning*. For
other types of geostatistical problems, please check the [Problems](problems.md)
section of the documentation.

Let's assume that we have spatial data with some variable that we want to predict
in a supervised learning setting. We load the data from a CSV file, and inspect
the available columns:

```@example workflow
using CSV
using DataFrames
gr(size=(800,400)) # hide

df = DataFrame(CSV.File("data/agriculture.csv"))

first(df, 5)
```

Columns `band1`, ..., `band4` represent four satellite bands for different
locations `(x,y)` in this spatial region. The column `crop` has the crop type
for each location that was labeled manually with the purpose of training a
learning model.

Because the labels are categorical variables, we need to inform the framework
the correct type:

```@example workflow
DataFrames.transform!(df, :crop => categorical => :crop)

first(df, 5)
```

We can now georeference the table and plot some of the spatial variables:

```@example workflow
Ω = georef(df, (:x,:y))

gr(format=:png) # hide
plot(Ω, (:band4,:crop), ms=0.2, mc=:viridis)
```

Similar to a generic statistical learning workflow, we split the data into "train"
and "test" sets. The main difference here is that our spatial `split` function
accepts a separating plane specified by its normal direction `(1,-1)`:

```@example workflow
Ωs, Ωt = split(Ω, 0.2, (1.,-1.))

plot(domain(Ωs), ms=0.2)
plot!(domain(Ωt), ms=0.2, mc=:green)
```

We can visualize the domain of the "train" (or source) set Ωs in black, and the
domain of the "test" (or target) set Ωt in green. We reserved 20% of the samples
to Ωs and 80% to Ωt. Internally, this spatial `split` function is implemented in
terms of efficient spatial partitioning operations, which were illustrated in the
previous section.

Let's define the learning task and the geostatistical learning problem. We want
to predict the crop type based on the four satellite bands. We will train the model
in Ωs where labels are available, and apply it to Ωt, which is our target:

```@example workflow
feats = [:band1,:band2,:band3,:band4]
label = :crop

𝒯 = ClassificationTask(feats, label)

𝒫 = LearningProblem(Ωs, Ωt, 𝒯)
```

GeoStats.jl is integrated with the [MLJ.jl](https://github.com/alan-turing-institute/MLJ.jl)
project, which means that we can solve geostatistical learning problems with any classical
learning model:

```@example workflow
using MLJ

ℳ = @load DecisionTreeClassifier

ℒ = PointwiseLearn(ℳ)
```

In this example, we selected a `PointwiseLearn` strategy to solve the geostatistical
learning problem. This strategy consists of applying the learning model pointwise for
every point in the spatial data:

```@example workflow
Ω̂t = solve(𝒫, ℒ)
```

## Plotting solutions

We note that the solution to a geostatistical learning problem is a spatial
data object, and we can inspect it with the same methods already described above.
This also means that we can plot the solution directly, side by side with the
true label in this synthetic example:

```@example workflow
p̂ = plot(Ω̂t, ms=0.2, mc=:viridis, title="crop (prediction)")
p = plot(Ωt, (:crop,), ms=0.2, mc=:viridis)

plot(p̂, p)
```

Visually, the learning model has succeeded predicting the crop. We can also
estimate the generalization error of the geostatistical solver with [spatial
validation methods](validation.md) such as block cross-validation and
leave-ball-out, but these methods deserve a separate tutorial.

With this example we conclude the basic workflow. To get familiar with other
features of the project, please check the tutorials and the reference guide.
