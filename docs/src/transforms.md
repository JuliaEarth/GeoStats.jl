# Table transforms

```@example transforms
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats, GeoStatsViz # hide
import WGLMakie as Mke # hide
```

We provide a very powerful list of transforms that were designed to
work seamlessly with geospatial data. These transforms are implemented
in different packages depending on how they interact with geometries.

The list of supported transforms is continuously growing. The following
code can be used to print an updated list in any project environment:

```@example transforms
# packages to print type tree
using InteractiveUtils
using AbstractTrees
using TransformsBase

# packages with transforms
using GeoStats
using CoDa

# define the tree of types
AbstractTrees.children(T::Type) = subtypes(T)

# print all currently available transforms
AbstractTrees.print_tree(TransformsBase.Transform)
```

Transforms at the leaves of the tree above should have a docstring with
more information on the available options. For example, the documentation
of the [`Select`](@ref) transform is shown below:

```@docs
Select
```

Transforms of type [`GeometricTransform`](@ref) operate on the underlying
geospatial domain, whereas transforms of type [`FeatureTransform`](@ref)
operate on the attribute table:

```@docs
Meshes.GeometricTransform
TableTransforms.FeatureTransform
```

Other transforms such as [`Detrend`](@ref) are defined in terms of both
the geospatial domain and the attribute table. All transforms and pipelines
implement the following functions:

```@docs
TableTransforms.isrevertible
TableTransforms.apply
TableTransforms.revert
TableTransforms.reapply
```

## Geometric transforms

Please check the [Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl)
documentation for an updated list of geometric transforms. As an example
consider the rotation of geospatial data over a Cartesian grid:

```@example transforms
# geospatial domain
Ω = georef((Z=rand(10, 10),))

# apply geometric transform
Ωr = Ω |> Rotate(Angle2d(π/4))

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], Ω.geometry, color = Ω.Z)
viz(fig[1,2], Ωr.geometry, color = Ωr.Z)
fig
```

## Feature transforms

Please check the [TableTransforms.jl](https://github.com/JuliaML/TableTransforms.jl)
documentation for an updated list of feature transforms.
The [CoDa.jl](https://github.com/JuliaEarth/CoDa.jl) package
also provides transforms for compositional features. As an
example consider the following features over a Cartesian grid
and their statistics:

```@example transforms
using DataFrames

# table of features and domain
tab = DataFrame(a=rand(1000), b=randn(1000), c=rand(1000))
dom = CartesianGrid(100, 100)

# georeference table onto domain
Ω = georef(tab, dom)

# describe features
describe(values(Ω))
```

We can create a pipeline that transforms the features
`:a` and `:c` to their normal quantile (or scores):

```@example transforms
pipe = Select(:a, :c) → Quantile()

Ω̄, cache = apply(pipe, Ω)

describe(values(Ω̄))
```

We can then revert the transform given any new geospatial data in the
transformed sample space:

```@example transforms
Ωₒ = revert(pipe, Ω̄, cache)

describe(values(Ωₒ))
```

## Geostatistical transforms

Bellow is the current list of transforms that operate on both the
geometries and features of geospatial data. They are implemented in the
[GeoStatsBase.jl](https://github.com/JuliaEarth/GeoStatsBase.jl) package.

### UniqueCoords

```@docs
UniqueCoords
```

### Detrend

```@docs
Detrend
```

### Potrace

```@docs
Potrace
```