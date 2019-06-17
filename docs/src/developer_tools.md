# Developer tools

Various tools are made available that can be used to accelerate the process of writing
new geostatistical solvers. They are implemented in the
[GeoStatsBase.jl](https://github.com/juliohm/GeoStatsBase.jl) package.

## Solver macros

To define a new solver with the same interface of built-in solvers, the developer
can use solver macros:

```julia
@estimsolver MySolver begin
  @param variogram = GaussianVariogram()
  @param mean # no default parameter
  @global verbose = true
end
```

The `@estimsolver` macro defines a new estimation solver `MySolver`, a parameter type
`MySolverParam`, and an outer constructor that accepts parameters for each variable as
well as global parameters.

Similarly, simulation solvers can be created with the `@simsolver` macro.

```@docs
@estimsolver
@simsolver
```

## Domain navigation

To navigate through all locations of a (finite) spatial domain, we introduce the concept
of paths. This package defines various path types such as `SimplePath` and `RandomPath`
that can be used for iteration over any domain:

```julia
# prints 1, 2, ..., npoints(domain)
for location in SimplePath(domain)
  println(location)
end
```

```@docs
SimplePath
RandomPath
SourcePath
```

At a given location of a domain, we can query neighboring locations with the concept of
neighborhoods. Various neighborhood types such as `BallNeighborhood` can be used to find
all locations within a specified radius:

```julia
# define ball neighborhood with radius 10
neighborhood = Ballneighborhood(domain, 10.)

# find neighbors for all locations of the domain
for location in RandomPath(domain)
  neighbors = neighborhood(location)
end
```

```@docs
BallNeighborhood
CylinderNeighborhood
```

## Mapping spatial data

In GeoStats.jl, spatial data and domain types are disconnected from each other for many reasons:

- To enable agressive parallelism and to avoid expensive data copies
- To give developers the power of deciding when and where data is to be copied
- To enable higher-level comparison schemes such as cross-validation

To map spatial data onto a domain, we introduce the notion of mappers. For example, a `SimpleMapper`
can be used to find the mapping from domain locations to data locations for a given variable:

```julia
# construct a problem mapping data onto domain using SimpleMapper (default)
problem = EstimationProblem(..., mapper=SimpleMapper())

# get the mapping for the `:precipitation` variable
mapping = datamap(problem, :precipitation)

for (loc, datloc) in mapping
  println("Domain location $loc has data at spatial data index $datloc")
end
```

```@docs
SimpleMapper
CopyMapper
```

## Partitioning spatial data

To efficiently partition spatial data, we introduce the notion of partitioners. One can
loop over subsets of the data without allocating memory:

```julia
for dataview in partition(spatialdata, DirectionPartitioner(direction))
  # do something with view of data
end
```

Complex partition schemes can be produced hierarchically with a `HierarchicalPartitioner`.

```@docs
UniformPartitioner
PlanePartitioner
DirectionPartitioner
HierarchicalPartitioner
```
