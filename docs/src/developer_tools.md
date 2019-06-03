# Developer tools

Here we provide an overview of the tools implemented in the framework that can be used by developers
to accelerate the process of writing new geostatistical solvers. If you have any question, please don't
hesitate to ask in our [community](about/community.md) channel.

## Solver macros

To define a new solver with the same interface of built-in solvers, the developer can use solver macros:

```julia
@estimsolver MySolver begin
  @param variogram = GaussianVariogram()
  @param mean # no default parameter
  @global verbose = true
end
```

The `@estimsolver` macro defines a new estimation solver `MySolver`, a parameter type `MySolverParam`, and an
outer constructor that accepts parameters for each variable as well as global parameters.

Similarly, simulation solvers can be created with the `@simsolver` macro.

```@docs
@estimsolver
@simsolver
```

## Domain navigation

To navigate through all locations of a (finite) spatial domain, we introduce the concept of paths. This package
defines various path types such as `SimplePath` and `RandomPath` that can be used for iteration over any domain:

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

At a given location of a domain, we can query neighboring locations with the concept of neighborhoods. Various
neighborhood types such as `BallNeighborhood` can be used to find all locations within a specified radius:

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

## Solver example

For illustration purposes, we write an estimation solver that, for each location of the domain, assigns the
2-norm of the coordinates as the mean and the ∞-norm as the variance:

```@example normsolver
using GeoStatsBase
using GeoStatsDevTools
using LinearAlgebra: norm

# implement method for new solver
import GeoStatsBase: solve

@estimsolver NormSolver begin
  @param pmean = 2
  @param pvar  = Inf
end

function solve(problem::EstimationProblem, solver::NormSolver)
  pdomain = domain(problem)

  # results for each variable
  μs = []; σs = []

  for (var,V) in variables(problem)
    # get user parameters
    if var in keys(solver.params)
      varparams = solver.params[var]
    else
      varparams = NormSolverParam()
    end

    # allocate memory for result
    varμ = Vector{V}(undef, npoints(pdomain))
    varσ = Vector{V}(undef, npoints(pdomain))

    for location in SimplePath(pdomain)
      x = coordinates(pdomain, location)

      varμ[location] = norm(x, varparams.pmean)
      varσ[location] = norm(x, varparams.pvar)
    end

    push!(μs, var => varμ)
    push!(σs, var => varσ)
  end

  EstimationSolution(pdomain, Dict(μs), Dict(σs))
end;
```

We can test the newly defined solver on an estimation problem:

```@example normsolver
using GeoStats
using Plots
gr(size=(600,400)) # hide

# dummy spatial data with a single point and no value
spatialdata = PointSetData(Dict(:z => [NaN]), reshape([0.,0.], 2, 1))

# estimate on a regular grid
spatialgrid = RegularGrid{Float64}(100,100)

# the problem to be solved
problem = EstimationProblem(spatialdata, spatialgrid, :z)

# our new solver
solver = NormSolver()

solution = solve(problem, solver)

plot(solution)
png("images/normsolver.png") # hide
```
![](images/normsolver.png)
