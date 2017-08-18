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
    SGSParam(variogram=v, mean=m, degree=d, drifts=ds)

A set of parameters for a simulation variable.

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
@with_kw struct SGSParam
  variogram = GaussianVariogram()
  mean = nothing
  degree = nothing
  drifts = nothing
end

"""
    SeqGaussSim(var1=>param1, var2=>param2, ...)

A polyalgorithm sequential Gaussian simulation solver.

Each pair `var=>param` specifies the [`SGSParam`](@ref) `param`
for the simulation variable `var`.
"""
struct SeqGaussSim <: AbstractSimulationSolver
  params::Dict{Symbol,SGSParam}

  function SeqGaussSim(params...)
    new(Dict(params...))
  end
end

function solve_single(problem::SimulationProblem{<:AbstractDomain}, solver::SeqGaussSim)
  # retrieve data
  geodata = data(problem)
  rawdata = data(geodata)

  # determine coordinate type
  coordtypes = eltypes(coordinates(geodata))
  T = promote_type(coordtypes...)

  # store results on dictionary
  realization = Realization()

  # loop over target variables
  for var in variables(problem)
    # determine value type
    V = eltype(rawdata[var])

    # get user parameters
    if var ∈ keys(solver.params)
      varparams = solver.params[var]
    else
      varparams = SGSParam()
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

    # perform simulation
    varreal = solve_single(problem, var, estimator)

    # save result for variable
    realization[var] = varreal
  end

  realization
end

function solve_single(problem::SimulationProblem{<:AbstractDomain},
               var::Symbol, estimator::E) where {E<:AbstractEstimator}
  [] # TODO
end
