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

* `neighborhood` - Search neighborhood (default to nothing)
* `maxneighbors` - Maximum number of neighbors (default to 10)

The `neighborhood` option can be used to perform local Kriging
with a sliding neighborhood. In this case, the option `maxneighbors`
determines the maximum number of neighbors in the Kriging system.

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
  @param neighborhood = nothing
  @param maxneighbors = 10
end

function preprocess(problem::EstimationProblem, solver::Kriging)
  # retrieve problem info
  pdomain = domain(problem)

  # result of preprocessing
  preproc = Dict{Symbol,Tuple}()

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

    # determine which neighborhood and path to use
    if varparams.neighborhood ≠ nothing
      neighborhood = varparams.neighborhood
      sources = collect(keys(datamap(problem, var)))
      path = SourcePath(pdomain, sources)
    else
      neighborhood = nothing
      path = SimplePath(pdomain)
    end

    # determine maximum number of conditioning neighbors
    maxneighbors = varparams.maxneighbors

    preproc[var] = (estimator, path, neighborhood, maxneighbors)
  end

  preproc
end

function solve(problem::EstimationProblem, solver::Kriging)
  # preprocess user input
  preproc = preprocess(problem, solver)

  # results for each variable
  μs = []; σs = []

  for (var, V) in variables(problem)
    neighborhood = preproc[var][3]

    if neighborhood ≠ nothing
      # perform local Kriging
      varμ, varσ = solve_locally(problem, var, preproc)
    else
      # perform global Kriging
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
    estimator, path, neighborhood, maxneighbors = preproc[var]

    # determine value type
    V = variables(problem)[var]

    # pre-allocate memory for result
    varμ = Vector{V}(undef, npoints(pdomain))
    varσ = Vector{V}(undef, npoints(pdomain))

    # pre-allocate memory for coordinates
    xₒ = MVector{ndims(pdomain),coordtype(pdomain)}(undef)
    x  = MVector{ndims(pdomain),coordtype(pdomain)}(undef)

    # keep track of estimated locations
    estimated = falses(npoints(pdomain))

    # consider data locations as already estimated
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
        nneigh = 0
        for l in path
          if estimated[l]
            coordinates!(x, pdomain, l)
            if isneighbor(neighborhood, xₒ, x)
              nneigh += 1
              neighbors[nneigh] = l
            end
          end
          nneigh == maxneighbors && break
        end

        # final set of neighbors
        nview = view(neighbors, 1:nneigh)

        # update neighbors coordinates
        coordinates!(X, pdomain, nview)

        Xview = view(X,:,1:nneigh)
        zview = view(varμ, nview)

        # fit estimator to data
        krig = fit(estimator, Xview, zview)

        # mean and variance
        μ, σ² = predict(krig, xₒ)

        # save and continue
        varμ[location] = μ
        varσ[location] = σ²
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
    estimator, path, neighborhood, maxneighbors = preproc[var]

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
