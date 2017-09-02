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
  path = :random
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

function solve(problem::SimulationProblem, solver::SeqGaussSim)
  # sanity checks
  @assert keys(solver.params) ⊆ keys(variables(problem)) "invalid variable names in solver parameters"

  warn("SGSIM is not fully implemented")

  # map spatial data to domain
  mapper = SimpleMapper(data(problem), domain(problem), variables(problem))

  # save results in a dictionary
  realizations = Dict{Symbol,Vector{Vector}}()

  # loop over target variables
  for (var,V) in variables(problem)
    varreals = [solve_single(problem, var, solver, mapper) for i=1:nreals(problem)]

    push!(realizations, var => varreals)
  end

  # return solution
  SimulationSolution(domain(problem), realizations)
end

function solve_single(problem::SimulationProblem, var::Symbol,
                      solver::SeqGaussSim, mapper::SimpleMapper)
  # retrieve problem info
  pdomain = domain(problem)

  # determine coordinate type
  T = promote_type([T for (var,T) in coordinates(problem)]...)

  # determine value type
  V = variables(problem)[var]

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

  #-------------------
  # START SIMULATION
  #-------------------

  # result for variable
  varreal = Vector{V}(npoints(pdomain))

  # keep track of simulated locations
  simulated = falses(npoints(pdomain))

  # consider data locations as already simulated
  for (loc, val) in mapping(mapper, var)
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
          # draw from conditional
          μ, σ² = estimate(estimator, coordinates(pdomain, location))
          varreal[location] = μ + √σ²*randn(V)
        catch e
          if e isa SingularException
            # draw from marginal
            varreal[location] = randn(V)
          end
        end
      end

      # mark location as simulated and continue
      simulated[location] = true
    end
  end

  varreal
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
