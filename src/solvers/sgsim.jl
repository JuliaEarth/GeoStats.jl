# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    SeqGaussSim(var₁=>param₁, var₂=>param₂, ...)

A sequential Gaussian simulation solver.

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
* `distance`     - Distance used to find nearest neighbors (default to `Euclidean()`)
* `path`         - Simulation path (default to `RandomPath`)

For each location in the simulation `path`, a maximum number of
neighbors `maxneighbors` is used to fit a Gaussian distribution.
The nearest neighbors are searched according to a `distance`
or according to a `neighborhood` when the latter is provided.
"""
@simsolver SeqGaussSim begin
  @param variogram = GaussianVariogram()
  @param mean = nothing
  @param degree = nothing
  @param drifts = nothing
  @param maxneighbors = 10
  @param neighborhood = nothing
  @param distance = Euclidean()
  @param path = nothing
end

function preprocess(problem::SimulationProblem, solver::SeqGaussSim)
  # retrieve problem info
  pdomain = domain(problem)

  params = []
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
      estimator = UniversalKriging(varparams.variogram, varparams.degree, ndims(pdomain))
    elseif varparams.mean ≠ nothing
      estimator = SimpleKriging(varparams.variogram, varparams.mean)
    else
      estimator = OrdinaryKriging(varparams.variogram)
    end

    # determine marginal distribution
    marginal = Normal()

    # equivalent parameters for SeqSim solver
    param = SeqSimParam(estimator=estimator, marginal=marginal,
                        maxneighbors=varparams.maxneighbors,
                        neighborhood=varparams.neighborhood,
                        distance=varparams.distance,
                        path=varparams.path)

    push!(params, var => param)
  end

  preprocess(problem, SeqSim(Dict(params)))
end

function solve_single(problem::SimulationProblem, var::Symbol,
                      solver::SeqGaussSim, preproc)
  solve_single(problem, var, SeqSim(), preproc)
end
