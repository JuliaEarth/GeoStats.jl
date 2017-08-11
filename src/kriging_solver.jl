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
    KrigParam(variogram=v, mean=m, degree=d, drifts=ds)

A set of parameters for a Kriging variable.

## Parameters

* `v`  - the variogram model (default to `GaussianVariogram()`)
* `m`  - Simple Kriging mean
* `d`  - Universal Kriging degree
* `ds` - External Drift Kriging drift functions

Latter options override former options. For example, by specifying
`ds`, the user is telling the algorithm to ignore `d` and `m`.
If no option is specified, Ordinary Kriging is used by default with
the variogram `v` only.
"""
@with_kw struct KrigParam
  variogram = GaussianVariogram()
  mean = nothing
  degree = nothing
  drifts = nothing
end

"""
    Kriging(var1=>param1, var2=>param2, ...)

A polyalgorithm Kriging estimation solver.

Each pair `var=>param` specifies the [`KrigParam`](@ref) `param`
for the Kriging variable `var`.
"""
struct Kriging <: AbstractEstimationSolver
  params::Dict{Symbol,KrigParam}

  function Kriging(params...)
    new(Dict(params...))
  end
end

function solve(problem::EstimationProblem{D}, solver::Kriging) where {D<:AbstractDomain}
  # sanity checks
  @assert keys(solver.params) ⊆ variables(problem) "invalid variable names in solver parameters"

  # retrieve data
  geodata = data(problem)
  rawdata = data(geodata)

  # determine coordinate type
  coordtypes = eltypes(coordinates(geodata))
  T = promote_type(coordtypes...)

  # store results on dictionary
  μdict = Dict{Symbol,Vector}()
  σdict = Dict{Symbol,Vector}()

  # loop over target variables
  for var in variables(problem)
    # determine value type
    V = eltype(rawdata[var])

    # get user parameters
    if var ∈ keys(solver.params)
      varparams = solver.params[var]
    else
      varparams = KrigParam()
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
    μdict[var] = varμ
    σdict[var] = varσ
  end

  EstimationSolution(domain(problem), μdict, σdict)
end

function solve(problem::EstimationProblem{D}, var::Symbol,
               estimator::E) where {D<:AbstractDomain,E<:AbstractEstimator}
  # retrieve data
  geodata = data(problem)
  rawdata = data(geodata)
  cnames = coordnames(geodata)

  # find valid data for variable
  vardata = rawdata[[cnames...,var]]
  completecases!(vardata)

  # convert data into arrays
  X = convert(Array, vardata[cnames])'
  z = convert(Array, vardata[var])

  # fit estimator to data
  fit!(estimator, X, z)

  # retrieve spatial domain
  pdomain = domain(problem)

  # pre-allocate memory for result
  varμ = Array{eltype(z)}(npoints(pdomain))
  varσ = Array{eltype(z)}(npoints(pdomain))

  # estimation loop
  for location in SimplePath(pdomain)
    x = coords(pdomain, location)
    μ, σ² = estimate(estimator, x)

    varμ[location] = μ
    varσ[location] = σ²
  end

  # return mean and variance
  varμ, varσ
end
