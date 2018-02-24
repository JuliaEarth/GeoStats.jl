# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
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

## Examples

Solve the variable `:var₁` with Simple Kriging by specifying
the `mean`, and the variable `:var₂` with Universal Kriging
by specifying the `degree` and the `variogram` model.

```julia
julia> Kriging(
  :var₁ => @NT(mean=1.),
  :var₂ => @NT(degree=1, variogram=SphericalVariogram(range=20.))
)
```

Solve all variables of the problem with the default parameters
(i.e. Ordinary Kriging with unit Gaussian variogram):

```julia
julia> Kriging()
```

### Notes

The prefix `@NT` extends for `NamedTuple`. It won't be necessary
in Julia v0.7 and beyond.
"""
@estimsolver Kriging begin
  @param variogram = GaussianVariogram()
  @param mean = nothing
  @param degree = nothing
  @param drifts = nothing
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
      estimator = ExternalDriftKriging{T,V}(varaparams.variogram, varparams.drifts)
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

function solve(problem::EstimationProblem, var::Symbol, estimator::E) where {E<:AbstractEstimator}
  # retrieve data
  pdata = data(problem)

  # find valid data for variable
  X, z = valid(pdata, var)

  # fit estimator to data
  fit!(estimator, X, z)

  # retrieve spatial domain
  pdomain = domain(problem)

  # pre-allocate memory for result
  varμ = Vector{eltype(z)}(npoints(pdomain))
  varσ = Vector{eltype(z)}(npoints(pdomain))

  # estimation loop
  for location in SimplePath(pdomain)
    x = coordinates(pdomain, location)
    μ, σ² = estimate(estimator, x)

    varμ[location] = μ
    varσ[location] = σ²
  end

  # return mean and variance
  varμ, varσ
end
