## Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
##
## Permission to use, copy, modify, and/or distribute this software for any
## purpose with or without fee is hereby granted, provided that the above
## copyright notice and this permission notice appear in all copies.
##
## THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
## WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
## ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
## WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
## ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
## OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

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
  T = promote_type([T for (var,T) in coordinates(problem)]...)

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
  varreal = Vector{V}(npoints(pdomain))

  # keep track of simulated locations
  simulated = falses(npoints(pdomain))

  # consider data locations as already simulated
  for (loc, datloc) in datamap(problem, var)
    simulated[loc] = true
    varreal[loc] = value(pdata, datloc, var)
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
        varreal[location] = randn(V)
      else
        # build coordinates and observation arrays
        X = Matrix{T}(ndims(pdomain), length(neighbors))
        z = Vector{V}(length(neighbors))
        for (j, neighbor) in enumerate(neighbors)
          X[:,j] = coordinates(pdomain, neighbor)
          z[j]   = varreal[neighbor]
        end

        # build Kriging system
        fit!(estimator, X, z)

        try
          # estimate mean and variance
          μ, σ² = estimate(estimator, coordinates(pdomain, location))

          # fix possible numerical issues
          O = zero(typeof(σ²))
          σ² < O && (σ² = O)

          # draw from conditional
          varreal[location] = μ + √σ²*randn(V)
        catch e
          if e isa LinAlg.SingularException
            # draw from marginal
            varreal[location] = randn(V)
          else
            rethrow(e)
          end
        end
      end

      # mark location as simulated and continue
      simulated[location] = true
    end
  end

  varreal
end
