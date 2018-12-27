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
* `maxneighbors` - Maximum number of neighbors (default to 100)

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
  @param maxneighbors = 100
end

function solve(problem::EstimationProblem, solver::Kriging)
  # sanity checks
  @assert keys(solver.params) ⊆ keys(variables(problem)) "invalid variable names in solver parameters"

  # determine problem coordinate type
  T = coordtype(data(problem))

  # results for each variable
  μs = []; σs = []

  # loop over target variables
  for (var,V) in variables(problem)
    # get user parameters
    if var ∈ keys(solver.params)
      varparams = solver.params[var]
    else
      varparams = KrigingParam()
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

    # perform estimation
    varμ, varσ = solve(problem, var, estimator)

    # save result for variable
    push!(μs, var => varμ)
    push!(σs, var => varσ)
  end

  EstimationSolution(domain(problem), Dict(μs), Dict(σs))
end

function solve(problem::EstimationProblem, var::Symbol, estimator::E) where {E<:KrigingEstimator}
  # retrieve problem info
  pdata = data(problem)
  pdomain = domain(problem)

  # find valid data for variable
  X, z = valid(pdata, var)

  # fit estimator to data
  fit!(estimator, X, z)

  # pre-allocate memory for result
  varμ = Vector{eltype(z)}(undef, npoints(pdomain))
  varσ = Vector{eltype(z)}(undef, npoints(pdomain))

  # pre-allocate memory for coordinates
  xₒ = MVector{ndims(pdomain),coordtype(pdomain)}(undef)

  # estimation loop
  for location in SimplePath(pdomain)
    coordinates!(xₒ, pdomain, location)

    μ, σ² = predict(estimator, xₒ)

    varμ[location] = μ
    varσ[location] = σ²
  end

  # return mean and variance
  varμ, varσ
end
