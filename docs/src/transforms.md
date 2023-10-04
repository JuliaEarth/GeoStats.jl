# Geospatial transforms

```@example transforms
using JSServe: Page # hide
Page(exportable=true, offline=true) # hide

using GeoStats # hide
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

Transforms of type [`FeatureTransform`](@ref) operate on the attribute table,
whereas transforms of type [`GeometricTransform`](@ref) operate on the underlying
geospatial domain:

```@docs
TableTransforms.FeatureTransform
Meshes.GeometricTransform
```

Other transforms such as [`Detrend`](@ref) are defined in terms of both
the geospatial domain and the attribute table. All transforms and pipelines
implement the following functions:

```@docs
TransformsBase.isrevertible
TransformsBase.isinvertible
TransformsBase.apply
TransformsBase.revert
TransformsBase.reapply
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

## Geostatistical transforms

Bellow is the current list of transforms that operate on both the
geometries and features of geospatial data. They are implemented in the
[GeoStatsBase.jl](https://github.com/JuliaEarth/GeoStatsBase.jl) package.

### UniqueCoords

```@docs
UniqueCoords
```

```@example transforms
# point set with repeated points
X = rand(2, 50)
Ω = georef((Z=rand(100),), [X X])
```

```@example transforms
# discard repeated points
𝒰 = Ω |> UniqueCoords()
```

### Detrend

```@docs
Detrend
```

```@example transforms
# quadratic trend + random noise
r = range(-1, stop=1, length=100)
μ = [x^2 + y^2 for x in r, y in r]
ϵ = 0.1rand(100, 100)
Ω = georef((Z=μ+ϵ,))

# detrend and obtain noise component
𝒩 = Ω |> Detrend(:Z, degree=2)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], Ω.geometry, color = Ω.Z)
viz(fig[1,2], 𝒩.geometry, color = 𝒩.Z)
fig
```

### Potrace

```@docs
Potrace
```

```@example transforms
# continuous feature
Z = [sin(i/10) + sin(j/10) for i in 1:100, j in 1:100]

# binary mask
M = Z .> 0

# georeference data
Ω = georef((Z=Z, M=M))

# trace polygons using mask
𝒯 = Ω |> Potrace(:M)

fig = Mke.Figure(resolution = (800, 400))
viz(fig[1,1], Ω.geometry, color = Ω.Z)
viz(fig[1,2], 𝒯.geometry, color = 𝒯.Z)
fig
```

```@example transforms
𝒯.geometry
```

### Rasterize

```@docs
Rasterize
```

```@example transforms
A = [1, 2, 3, 4, 5]
B = [1.1, 2.2, 3.3, 4.4, 5.5]
p1 = PolyArea((2, 0), (6, 2), (2, 2))
p2 = PolyArea((0, 6), (3, 8), (0, 10))
p3 = PolyArea((3, 6), (9, 6), (9, 9), (6, 9))
p4 = PolyArea((7, 0), (10, 0), (10, 4), (7, 4))
p5 = PolyArea((1, 3), (5, 3), (6, 6), (3, 8), (0, 6))
gt = georef((; A, B), [p1, p2, p3, p4, p5])

nt = gt |> Rasterize(20, 20)

viz(nt.geometry, color = nt.A)
```

### Interpolate

```@docs
Interpolate
InterpolateNeighbors
```

```@example transforms
table = (; Z=[1.,0.,1.])
coord = [(25.,25.), (50.,75.), (75.,50.)]
geotable = georef(table, coord)

grid = CartesianGrid(100, 100)

model = Kriging(GaussianVariogram(range=35.))

interp = geotable |> Interpolate(grid, model)

viz(interp.geometry, color = interp.Z)
```