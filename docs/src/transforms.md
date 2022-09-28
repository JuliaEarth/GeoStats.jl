# Transforms

[TableTranfrorms.jl](https://github.com/JuliaML/TableTransforms.jl)
provides a very powerful list of transforms that work seamlessly
with our geospatial data types. Other packages such as
[CoDa.jl](https://github.com/JuliaEarth/CoDa.jl) provide additional
transforms for custom variable types.

## Overview

The list of supported transforms is continuously growing. The following
code can be used to print an updated list in any project environment:

```@example transforms
# packages to print type tree
using InteractiveUtils
using AbstractTrees
using TransformsAPI

# packages with transforms
using GeoStats
using CoDa

# define the tree of types
AbstractTrees.children(T::Type) = subtypes(T)

# print all currently available transforms
AbstractTrees.print_tree(TransformsAPI.Transform)
```

Transforms at the leaves of the tree above should have a docstring with
more information on the available options. For example, the docstring
of the `Select` transform is shown below:

```@docs
Select
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