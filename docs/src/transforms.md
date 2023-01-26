# Table transforms

[TableTranfrorms.jl](https://github.com/JuliaML/TableTransforms.jl)
provides a very powerful list of transforms that were designed to
work seamlessly with geospatial data. Other packages such as
[CoDa.jl](https://github.com/JuliaEarth/CoDa.jl) provide additional
transforms for custom variable types.

## Overview

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
the geospatial domain and the attribute table:

```@docs
Detrend
```

All transforms and pipelines implement the following functions:

```@docs
TableTransforms.isrevertible
TableTransforms.apply
TableTransforms.revert
TableTransforms.reapply
```

## Examples

Consider the following geospatial data:

```@example transforms
using GeoStats
using DataFrames

tab = DataFrame(a=rand(1000), b=randn(1000), c=rand(1000))
dom = CartesianGrid(100, 100)

Ω = georef(tab, dom)

describe(values(Ω))
```

We can create a pipeline that transforms the varialbes `:a` and `:c` to
their normal quantile (or scores):

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