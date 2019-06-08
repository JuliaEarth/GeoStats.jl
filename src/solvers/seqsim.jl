# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    SeqSim(var₁=>param₁, var₂=>param₂, ...)

A sequential simulation solver.

## Parameters

* `estimator`    - Estimator used to construct conditional distribution
                   (default to `OrdinaryKriging(GaussianVariogram())`)
* `marginal`     - Marginal distribution used when neighbors are not available
                   (default to `Normal()`)
* `maxneighbors` - Maximum number of neighbors (default to 10)
* `neighborhood` - Search neighborhood (default to `nothing`)
* `distance`     - Distance used to find nearest neighbors (default to `Euclidean()`)
* `path`         - Simulation path (default to `RandomPath`)

For each location in the simulation `path`, a maximum number of
neighbors `maxneighbors` is used to fit a Gaussian distribution.
The nearest neighbors are searched according to a `distance`
or according to a `neighborhood` when the latter is provided.
"""
@simsolver SeqSim begin
  @param estimator = OrdinaryKriging(GaussianVariogram())
  @param marginal = Normal()
  @param maxneighbors = 10
  @param neighborhood = nothing
  @param distance = Euclidean()
  @param path = nothing
end

function preprocess(problem::SimulationProblem, solver::SeqSim)
  # retrieve problem info
  pdomain = domain(problem)

  # result of preprocessing
  preproc = Dict{Symbol,NamedTuple}()

  for (var, V) in variables(problem)
    # get user parameters
    if var ∈ keys(solver.params)
      varparams = solver.params[var]
    else
      varparams = SeqSimParam()
    end

    # determine which estimator to use
    estimator = varparams.estimator

    # determine marginal distribution
    marginal = varparams.marginal

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
      # find locations with data
      varlocs = collect(keys(datamap(problem, var)))
      if isempty(varlocs)
        # fallback to local search wiith a neighborhood
        T = coordtype(pdomain)
        neighborhood = BallNeighborhood(pdomain, T(10))
        neighsearcher = LocalNeighborSearcher(pdomain, maxneighbors,
                                              neighborhood, path)
      else
        # nearest neighbor search with a distance
        distance = varparams.distance
        neighsearcher = NearestNeighborSearcher(pdomain, varlocs,
                                                maxneighbors, distance)
      end
    end

    # save preprocessed input
    preproc[var] = (estimator=estimator, marginal=marginal,
                    path=path, maxneighbors=maxneighbors,
                    neighsearcher=neighsearcher)
  end

  preproc
end

function solve_single(problem::SimulationProblem, var::Symbol,
                      solver::SeqSim, preproc)
  # retrieve problem info
  pdata = data(problem)
  pdomain = domain(problem)

  # unpack preprocessed parameters
  estimator, marginal, path, maxneighbors, neighsearcher = preproc[var]

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
        realization[location] = rand(marginal)
      else
        # final set of neighbors
        nview = view(neighbors, 1:nneigh)

        # update neighbors coordinates
        coordinates!(X, pdomain, nview)

        Xview = view(X,:,1:nneigh)
        zview = view(realization, nview)

        # build Kriging system
        krig = KrigingEstimators.fit(estimator, Xview, zview)

        if status(krig)
          # estimate mean and variance
          μ, σ² = predict(krig, xₒ)

          # draw from conditional
          realization[location] = μ + √σ²*randn(V)
        else
          # draw from marginal
          realization[location] = rand(marginal)
        end
      end

      # mark location as simulated and continue
      simulated[location] = true
    end
  end

  realization
end
