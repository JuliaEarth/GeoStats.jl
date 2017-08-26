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
  path = :simple
  neighradius = 10.
  maxneighbors = 10
end

"""
    SeqGaussSim(var1=>param1, var2=>param2, ...)

A polyalgorithm sequential Gaussian simulation solver.

Each pair `var=>param` specifies the [`SGSParam`](@ref) `param`
for the simulation variable `var`. In order to avoid boilerplate
code, the constructor expects pairs of `Symbol` and `NamedTuple`
instead. See [`Kriging`](@ref) documentation for examples.
"""
struct SeqGaussSim <: AbstractSimulationSolver
  params::Dict{Symbol,SGSParam}

  SeqGaussSim(params::Dict{Symbol,SGSParam}) = new(params)
end

function SeqGaussSim(params...)
  # build dictionary for inner constructor
  dict = Dict{Symbol,SGSParam}()

  # convert named tuples to SGS parameters
  for (varname, varparams) in params
    kwargs = [k => v for (k,v) in zip(keys(varparams), varparams)]
    push!(dict, varname => SGSParam(; kwargs...))
  end

  SeqGaussSim(dict)
end

function solve(problem::SimulationProblem{<:AbstractDomain}, solver::SeqGaussSim)
  # sanity checks
  @assert keys(solver.params) ⊆ variables(problem) "invalid variable names in solver parameters"

  # retrieve problem info
  geodata = data(problem)
  rawdata = data(geodata)
  pdomain = domain(problem)
  targetvars = variables(problem)

  # map spatial data to domain
  mapper = SimpleMapper(geodata, pdomain, targetvars)

  # determine coordinate type
  coordtypes = eltypes(coordinates(geodata))
  T = promote_type(coordtypes...)

  # process user input
  params = Dict()
  for var in targetvars
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

    # determine which path to use
    if varparams.path == :simple
      path = SimplePath(pdomain)
    elseif varparams.path == :random
      path = RandomPath(pdomain)
    else
      error("invalid path type")
    end

    # determine which neighborhood to use
    neighborhood = SphereNeighborhood(pdomain, varparams.neighradius)

    # determine maximum number of conditioning neighbors
    maxneighbors = varparams.maxneighbors

    # save parameters for variable
    params[var] = Dict(:estimator    => estimator,
                       :path         => path,
                       :neighborhood => neighborhood,
                       :maxneighbors => maxneighbors,
                       :coordtype    => T,
                       :valuetype    => V)
  end

  # realization loop
  realizations = [solve_single(problem, params, mapper) for i=1:nreals(problem)]

  # return solution
  SimulationSolution(pdomain, realizations)
end

function solve_single(problem::SimulationProblem{<:AbstractDomain},
                      params::Dict, mapper::M) where {M<:AbstractMapper}
  # retrieve problem info
  pdomain = domain(problem)

  # save results on dictionary
  realization = Realization()

  # generate realization for each variable
  for var in variables(problem)
    # retrieve variable parameters
    estimator    = params[var][:estimator]
    path         = params[var][:path]
    neighborhood = params[var][:neighborhood]
    maxneighbors = params[var][:maxneighbors]
    T            = params[var][:coordtype]
    V            = params[var][:valuetype]

    # results for variable
    varreal = Vector{V}(npoints(pdomain))

    # keep track of simulated locations
    simulated = falses(npoints(pdomain))

    # consider data locations as already simulated
    for (loc,val) in mapping(mapper, var)
      simulated[loc] = true
      varreal[loc] = val
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
          varreal[location] = .5
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

          # estimate mean and variance
          μ, σ² = estimate(estimator, coordinates(pdomain, location))

          # draw from conditional
          varreal[location] = μ + √σ²*randn(V)
        end

        # mark location as simulated and continue
        simulated[location] = true
      end
    end

    # save realization for variable
    realization[var] = varreal
  end

  realization
end

# ------------
# IO methods
# ------------
function Base.show(io::IO, solver::SeqGaussSim)
  print(io, "SeqGaussSim solver")
end

function Base.show(io::IO, ::MIME"text/plain", solver::SeqGaussSim)
  println(io, solver)
  for (varname, varparams) in solver.params
    if varparams.drifts ≠ nothing
      println(io, "  - $varname => External Drift Kriging")
    elseif varparams.degree ≠ nothing
      println(io, "  - $varname => Universal Kriging")
    elseif varparams.mean ≠ nothing
      println(io, "  - $varname => Simple Kriging")
    else
      println(io, "  - $varname => Ordinary Kriging")
    end
  end
end
