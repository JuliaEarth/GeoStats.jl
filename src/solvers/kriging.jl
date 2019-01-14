# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    Kriging(var₁=>param₁, var₂=>param₂, ...)

A polyalgorithm Kriging estimation solver.

Each pair `var=>param` specifies the `KrigingParam` `param`
for the Kriging variable `var`. In order to avoid boilerplate
code, the constructor expects pairs of `Symbol` and `NamedTuple`
instead.

## Parameters

* `variogram` - Variogram model (default to `GaussianVariogram()`)
* `mean`      - Simple Kriging mean
* `degree`    - Universal Kriging degree
* `drifts`    - External Drift Kriging drift functions

Latter options override former options. For example, by specifying
`drifts`, the user is telling the algorithm to ignore `degree` and
`mean`. If no option is specified, Ordinary Kriging is used by
default with the `variogram` only.

* `maxneighbors` - Maximum number of neighbors (default to `nothing`)
* `neighborhood` - Search neighborhood (default to `nothing`)
* `searchoffset` - Offset to speed up neighborhood search (default to `-maxneighbors`)

The `maxneighbors` option can be used to perform approximate Kriging
with a subset of data points per estimation location. Two neighborhood
search methods are available depending on the value of `neighborhood`:

If a `neighborhood` is provided, local Kriging is performed by
sliding the `neighborhood` in the domain. All points inside of
the neighborhood are considered in the estimation. The option
`searchoffset` can be used to tune the performance of the
neighborhood search.

If `neighborhood` is not provided, the Kriging system is built
using the nearest neighbors of the location in the domain,
regardless of how far they are.

## Examples

Solve the variable `:var₁` with Simple Kriging by specifying
the `mean`, and the variable `:var₂` with Universal Kriging
by specifying the `degree` and the `variogram` model.

```julia
julia> Kriging(
  :var₁ => (mean=1.,),
  :var₂ => (degree=1, variogram=SphericalVariogram(range=20.))
)
```

Solve all variables of the problem with the default parameters
(i.e. Ordinary Kriging with unit Gaussian variogram):

```julia
julia> Kriging()
```
"""
@estimsolver Kriging begin
  @param variogram = GaussianVariogram()
  @param mean = nothing
  @param degree = nothing
  @param drifts = nothing
  @param maxneighbors = nothing
  @param metric = Euclidean()
  @param neighborhood = nothing
  @param searchoffset = nothing
end

function preprocess(problem::EstimationProblem, solver::Kriging)
  # retrieve problem info
  pdomain = domain(problem)

  # result of preprocessing
  preproc = Dict{Symbol,NamedTuple}()

  for (var, V) in variables(problem)
    # get user parameters
    if var ∈ keys(solver.params)
      varparams = solver.params[var]
    else
      varparams = KrigingParam()
    end

    # determine which Kriging variant to use
    if varparams.drifts ≠ nothing
      estimator = ExternalDriftKriging(varparams.variogram, varparams.drifts)
    elseif varparams.degree ≠ nothing
      estimator = UniversalKriging(varparams.variogram, varparams.degree)
    elseif varparams.mean ≠ nothing
      estimator = SimpleKriging(varparams.variogram, varparams.mean)
    else
      estimator = OrdinaryKriging(varparams.variogram)
    end

    # determine maximum number of conditioning neighbors
    maxneighbors = varparams.maxneighbors

    # determine path and neighborhood search method
    if varparams.maxneighbors ≠ nothing
      # create a path from the data and outwards
      locations = collect(keys(datamap(problem, var)))
      # use at most 10^3 points to generate path
      N = length(locations); M = ceil(Int, N/10^3)
      path = SourcePath(pdomain, view(locations,1:M:N))

      if varparams.neighborhood ≠ nothing
        # local search with a neighborhood
        neighborhood = varparams.neighborhood

        # offset to speedup neighborhood search
        if varparams.searchoffset ≠ nothing
          searchoffset = varparams.searchoffset
        else
          searchoffset = -maxneighbors
        end

        neighsearcher = LocalNeighborSearcher(pdomain, maxneighbors,
                                              neighborhood, path, searchoffset)
      else
        # nearest neighbor search with a metric
        metric = varparams.metric
        neighsearcher = NearestNeighborSearcher(pdomain, maxneighbors,
                                                metric, locations)
      end
    else
      # use all data points as neighbors
      path = SimplePath(pdomain)
      neighsearcher = nothing
    end

    # save preprocessed input
    preproc[var] = (estimator=estimator, path=path,
                    maxneighbors=maxneighbors,
                    neighsearcher=neighsearcher)
  end

  preproc
end

function solve(problem::EstimationProblem, solver::Kriging)
  # preprocess user input
  preproc = preprocess(problem, solver)

  # results for each variable
  μs = []; σs = []

  for (var, V) in variables(problem)
    if preproc[var].maxneighbors ≠ nothing
      # perform Kriging with reduced number of neighbors
      varμ, varσ = solve_locally(problem, var, preproc)
    else
      # perform Kriging with all data points as neighbors
      varμ, varσ = solve_globally(problem, var, preproc)
    end

    push!(μs, var => varμ)
    push!(σs, var => varσ)
  end

  EstimationSolution(domain(problem), Dict(μs), Dict(σs))
end

function solve_locally(problem::EstimationProblem, var::Symbol, preproc)
    # retrieve problem info
    pdata = data(problem)
    pdomain = domain(problem)

    # unpack preprocessed parameters
    estimator, path, maxneighbors, neighsearcher = preproc[var]

    # determine value type
    V = variables(problem)[var]

    # pre-allocate memory for result
    varμ = Vector{V}(undef, npoints(pdomain))
    varσ = Vector{V}(undef, npoints(pdomain))

    # pre-allocate memory for coordinates
    xₒ = MVector{ndims(pdomain),coordtype(pdomain)}(undef)

    # keep track of estimated locations
    estimated = falses(npoints(pdomain))
    for (loc, datloc) in datamap(problem, var)
      varμ[loc] = value(pdata, datloc, var)
      varσ[loc] = zero(V)
      estimated[loc] = true
    end

    # pre-allocate memory for neighbors
    neighbors = Vector{Int}(undef, maxneighbors)
    X = Matrix{coordtype(pdomain)}(undef, ndims(pdomain), maxneighbors)

    for location in path
      if !estimated[location]
        # coordinates of neighborhood center
        coordinates!(xₒ, pdomain, location)

        # find neighbors with previously estimated values
        nneigh = search!(neighbors, xₒ, neighsearcher, estimated)

        # final set of neighbors
        nview = view(neighbors, 1:nneigh)

        # update neighbors coordinates
        coordinates!(X, pdomain, nview)

        Xview = view(X,:,1:nneigh)
        zview = view(varμ, nview)

        # fit estimator to data
        krig = fit(estimator, Xview, zview)

        # save mean and variance
        μ, σ² = predict(krig, xₒ)
        varμ[location] = μ
        varσ[location] = σ²

        # mark location as estimated and continue
        estimated[location] = true
      end
    end

    varμ, varσ
end

function solve_globally(problem::EstimationProblem, var::Symbol, preproc)
    # retrieve problem info
    pdata = data(problem)
    pdomain = domain(problem)

    # unpack preprocessed parameters
    estimator, path, maxneighbors, neighsearcher = preproc[var]

    # determine value type
    V = variables(problem)[var]

    # pre-allocate memory for result
    varμ = Vector{V}(undef, npoints(pdomain))
    varσ = Vector{V}(undef, npoints(pdomain))

    # pre-allocate memory for coordinates
    xₒ = MVector{ndims(pdomain),coordtype(pdomain)}(undef)

    # fit estimator to data
    X, z = valid(pdata, var)
    krig = fit(estimator, X, z)

    for location in path
      coordinates!(xₒ, pdomain, location)

      μ, σ² = predict(krig, xₒ)

      varμ[location] = μ
      varσ[location] = σ²
    end

    varμ, varσ
end
