# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    SeqGaussSim(var₁=>param₁, var₂=>param₂, ...)

A polyalgorithm sequential Gaussian simulation solver.

Each pair `var=>param` specifies the `SeqGaussSimParam`
`param` for the simulation variable `var`. In order to avoid
boilerplate code, the constructor expects pairs of `Symbol`
and `NamedTuple` instead. See [`Kriging`](@ref) documentation
for examples.

## Parameters

* `variogram` - Variogram model (default to `GaussianVariogram()`)
* `mean`      - Simple Kriging mean
* `degree`    - Universal Kriging degree
* `drifts`    - External Drift Kriging drift functions

Latter options override former options. For example, by specifying
`drifts`, the user is telling the algorithm to ignore `degree` and
`mean`. If no option is specified, Ordinary Kriging is used by
default with the `variogram` only.

* `maxneighbors` - Maximum number of neighbors (default to 10)
* `neighborhood` - Search neighborhood (default to `nothing`)
* `metric`       - Metric used to find nearest neighbors (default to `Euclidean()`)
* `path`         - Simulation path (default to `RandomPath`)

For each location in the simulation `path`, a maximum number of
neighbors `maxneighbors` is used to fit a Gaussian distribution.
The nearest neighbors are searched according to a `metric`
or according to a `neighborhood` when the latter is provided.
"""
@simsolver SeqGaussSim begin
  @param variogram = GaussianVariogram()
  @param mean = nothing
  @param degree = nothing
  @param drifts = nothing
  @param maxneighbors = 10
  @param neighborhood = nothing
  @param metric = Euclidean()
  @param path = nothing
end

function preprocess(problem::SimulationProblem, solver::SeqGaussSim)
  # retrieve problem info
  pdomain = domain(problem)

  # result of preprocessing
  preproc = Dict{Symbol,NamedTuple}()

  for (var, V) in variables(problem)
    # get user parameters
    if var ∈ keys(solver.params)
      varparams = solver.params[var]
    else
      varparams = SeqGaussSimParam()
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

    # determine which path to use
    if varparams.path ≠ nothing
      path = varparams.path
    else
      path = RandomPath(pdomain)
    end

    # determine neighborhood search method
    if varparams.neighborhood ≠ nothing
      # local search with a neighborhood
      neighborhood = varparams.neighborhood
      neighsearcher = LocalNeighborSearcher(pdomain, maxneighbors,
                                            neighborhood, path)
    else
      # nearest neighbor search with a metric
      metric = varparams.metric
      varlocs = collect(keys(datamap(problem, var)))
      neighsearcher = NearestNeighborSearcher(pdomain, maxneighbors,
                                              metric, varlocs)
    end

    # save preprocessed input
    preproc[var] = (estimator=estimator, path=path,
                    maxneighbors=maxneighbors,
                    neighsearcher=neighsearcher)
  end

  preproc
end

function solve_single(problem::SimulationProblem, var::Symbol,
                      solver::SeqGaussSim, preproc)
  # retrieve problem info
  pdata = data(problem)
  pdomain = domain(problem)

  # unpack preprocessed parameters
  estimator, path, maxneighbors, neighsearcher = preproc[var]

  # determine value type
  V = variables(problem)[var]

  # pre-allocate memory for result
  realization = Vector{V}(undef, npoints(pdomain))

  # pre-allocate memory for coordinates
  xₒ = MVector{ndims(pdomain),coordtype(pdomain)}(undef)

  # pre-allocate memory for neighbors coordinates
  neighbors = Vector{Int}(undef, maxneighbors)
  X = Matrix{coordtype(pdomain)}(undef, ndims(pdomain), maxneighbors)

  # keep track of simulated locations
  simulated = falses(npoints(pdomain))
  for (loc, datloc) in datamap(problem, var)
    realization[loc] = value(pdata, datloc, var)
    simulated[loc] = true
  end

  # simulation loop
  for location in path
    if !simulated[location]
      # coordinates of neighborhood center
      coordinates!(xₒ, pdomain, location)

      # find neighbors with previously simulated values
      nneigh = search!(neighbors, xₒ, neighsearcher, simulated)

      # choose between marginal and conditional distribution
      if nneigh == 0
        # draw from marginal
        realization[location] = randn(V)
      else
        # final set of neighbors
        nview = view(neighbors, 1:nneigh)

        # update neighbors coordinates
        coordinates!(X, pdomain, nview)

        Xview = view(X,:,1:nneigh)
        zview = view(realization, nview)

        # build Kriging system
        krig = fit(estimator, Xview, zview)

        if status(krig)
          # estimate mean and variance
          μ, σ² = predict(krig, xₒ)

          # draw from conditional
          realization[location] = μ + √σ²*randn(V)
        else
          # draw from marginal
          realization[location] = randn(V)
        end
      end

      # mark location as simulated and continue
      simulated[location] = true
    end
  end

  realization
end
