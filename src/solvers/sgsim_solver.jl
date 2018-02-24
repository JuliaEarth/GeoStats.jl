# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
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
* `neighradius`  - Radius of search neighborhood (default to 10.)
* `maxneighbors` - Maximum number of neighbors (default to 10)
"""
@simsolver SeqGaussSim begin
  @param variogram = GaussianVariogram()
  @param mean = nothing
  @param degree = nothing
  @param drifts = nothing
  @param path = :random
  @param neighradius = 10.
  @param maxneighbors = 10
end

function solve_single(problem::SimulationProblem, var::Symbol, solver::SeqGaussSim)
  warn("SeqGaussSim not fully implemented, sorry!")
  # retrieve problem info
  pdata = data(problem)
  pdomain = domain(problem)

  # determine coordinate type
  T = hasdata(problem) ? coordtype(pdata) : coordtype(pdomain)

  # determine value type
  V = variables(problem)[var]

  # get user parameters
  if var ∈ keys(solver.params)
    varparams = solver.params[var]
  else
    varparams = SeqGaussSimParam()
  end

  # determine which Kriging variant to use
  if varparams.drifts ≠ nothing
    estimator = ExternalDriftKriging{T,V}(varaparams.variogram, varparams.drifts)
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
    error("invalid path type")
  end

  # determine which neighborhood to use
  neighborhood = BallNeighborhood(pdomain, varparams.neighradius)

  # determine maximum number of conditioning neighbors
  maxneighbors = varparams.maxneighbors

  #-------------------
  # START SIMULATION
  #-------------------

  # result for variable
  realization = Vector{V}(npoints(pdomain))

  # keep track of simulated locations
  simulated = falses(npoints(pdomain))

  # consider data locations as already simulated
  for (loc, datloc) in datamap(problem, var)
    realization[loc] = value(pdata, datloc, var)
    simulated[loc] = true
  end

  # simulation loop
  for location in path
    if !simulated[location]
      # find neighbors
      neighbors = neighborhood(location)

      # neighbors with previously simulated values
      neighbors = neighbors[view(simulated, neighbors)]

      # sample a subset of neighbors for computational purposes
      if length(neighbors) > maxneighbors
        neighbors = sample(neighbors, maxneighbors, replace=false)
      end

      # choose between marginal and conditional distribution
      if isempty(neighbors)
        # draw from marginal
        realization[location] = randn(V)
      else
        # build coordinates and observation arrays
        X = Matrix{T}(ndims(pdomain), length(neighbors))
        z = Vector{V}(length(neighbors))
        for (j, neighbor) in enumerate(neighbors)
          X[:,j] = coordinates(pdomain, neighbor)
          z[j]   = realization[neighbor]
        end

        # build Kriging system
        fit!(estimator, X, z)

        try
          # estimate mean and variance
          μ, σ² = estimate(estimator, coordinates(pdomain, location))

          # TODO: this portion of the code will be rewritten after
          # Julia v0.7. At the moment the linear algebra components
          # of the language do not provide a consistent, exception-free
          # way of checking for failure

          # fix possible numerical issues
          O = zero(typeof(σ²))
          σ² < O && (σ² = O)

          # draw from conditional
          realization[location] = μ + √σ²*randn(V)
        catch e
          if e isa LinAlg.SingularException
            # draw from marginal
            realization[location] = randn(V)
          else
            rethrow(e)
          end
        end
      end

      # mark location as simulated and continue
      simulated[location] = true
    end
  end

  realization
end
