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

* `path`         - Simulation path (default to :random)
* `neighborhood` - Search neighborhood (default to BallNeighborhood(domain, 5.))
* `maxneighbors` - Maximum number of neighbors (default to 100)
"""
@simsolver SeqGaussSim begin
  @param variogram = GaussianVariogram()
  @param mean = nothing
  @param degree = nothing
  @param drifts = nothing
  @param path = :random
  @param neighborhood = nothing
  @param maxneighbors = 100
end

function preprocess(problem::SimulationProblem, solver::SeqGaussSim)
  # retrieve problem info
  pdomain = domain(problem)

  # determine coordinate type
  T = coordtype(pdomain)

  # result of preprocessing
  preproc = Dict{Symbol,Tuple}()

  for (var, V) in variables(problem)
    # get user parameters
    if var ∈ keys(solver.params)
      varparams = solver.params[var]
    else
      varparams = SeqGaussSimParam()
    end

    # determine which Kriging variant to use
    if varparams.drifts ≠ nothing
      estimator = ExternalDriftKriging{T,V}(varparams.variogram, varparams.drifts)
    elseif varparams.degree ≠ nothing
      estimator = UniversalKriging{T,V}(varparams.variogram, varparams.degree)
    elseif varparams.mean ≠ nothing
      estimator = SimpleKriging{T,V}(varparams.variogram, varparams.mean)
    else
      estimator = OrdinaryKriging{T,V}(varparams.variogram)
    end

    # determine which path to use
    if varparams.path == :simple
      path = SimplePath(pdomain)
    elseif varparams.path == :random
      path = RandomPath(pdomain)
    else
      @error "invalid path type"
    end

    # determine which neighborhood to use
    if varparams.neighborhood ≠ nothing
      neighborhood = varaparams.neighborhood
    else
      neighborhood = BallNeighborhood(pdomain, 5.)
    end

    # determine maximum number of conditioning neighbors
    maxneighbors = varparams.maxneighbors

    preproc[var] = (estimator, path, neighborhood, maxneighbors)
  end

  preproc
end

function solve_single(problem::SimulationProblem, var::Symbol,
                      solver::SeqGaussSim, preproc)
  # retrieve problem info
  pdata = data(problem)
  pdomain = domain(problem)

  # unpack preprocessed parameters
  estimator, path, neighborhood, maxneighbors = preproc[var]

  # determine coordinate type
  T = coordtype(pdomain)

  # determine value type
  V = variables(problem)[var]

  # result for variable
  realization = Vector{V}(undef, npoints(pdomain))

  # keep track of simulated locations
  simulated = falses(npoints(pdomain))

  # consider data locations as already simulated
  for (loc, datloc) in datamap(problem, var)
    realization[loc] = value(pdata, datloc, var)
    simulated[loc] = true
  end

  # pre-allocate memory for coordinates
  xₒ = MVector{ndims(pdomain),coordtype(pdomain)}(undef)

  # pre-allocate memory for neighbors coordinates
  X  = Matrix{coordtype(pdomain)}(undef, ndims(pdomain), maxneighbors)

  # simulation loop
  for location in path
    if !simulated[location]
      # find neighbors
      neighbors = neighborhood(location)

      # neighbors with previously simulated values
      filter!(n -> simulated[n], neighbors)

      # retain a subset of neighbors for computational purposes
      if length(neighbors) > maxneighbors
        resize!(neighbors, maxneighbors)
      end

      # choose between marginal and conditional distribution
      if isempty(neighbors)
        # draw from marginal
        realization[location] = randn(V)
      else
        # count final number of neighbors
        m = length(neighbors)

        # update coordinates and observation arrays
        for j in 1:m
          coordinates!(view(X,:,j), pdomain, neighbors[j])
        end
        Xview = view(X,:,1:m)
        zview = view(realization, neighbors)

        # build Kriging system
        status = fit!(estimator, Xview, zview)

        if status
          # estimate mean and variance
          coordinates!(xₒ, pdomain, location)
          μ, σ² = predict(estimator, xₒ)

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
