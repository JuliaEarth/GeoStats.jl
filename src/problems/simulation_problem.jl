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
    SimulationProblem(spatialdata, domain, targetvars, nreals)
    SimulationProblem(domain, targetvars, nreals)

A spatial simulation problem on a given `domain` in which the
variables to be simulated are listed in `targetvars`.

For conditional simulation, the data of the problem is stored in
`spatialdata`.

For unconditional simulation, a dictionary `targetvars` must be
provided mapping variable names to their types.

In both cases, a number `nreals` of realizations is requested.

## Examples

Create a conditional simulation problem for porosity and permeability
with 100 realizations:

```julia
julia> SimulationProblem(spatialdata, domain, [:porosity,:permeability], 100)
```

Create an unconditional simulation problem for porosity and facies type
with 100 realizations:

```julia
julia> SimulationProblem(domain, Dict(:porosity => Float64, :facies => Int), 100)
```

### Notes

To check if a simulation problem has data (i.e. conditional vs.
unconditional) use the [`hasdata`](@ref) method.
"""
struct SimulationProblem{S<:Union{AbstractSpatialData,Void},D<:AbstractDomain} <: AbstractProblem
  spatialdata::S
  domain::D
  targetvars::Dict{Symbol,DataType}
  nreals::Int

  function SimulationProblem{S,D}(spatialdata, domain, targetvars, nreals
                                 ) where {S<:Union{AbstractSpatialData,Void},D<:AbstractDomain}
    @assert !isempty(targetvars) "target variables must be specified"
    @assert nreals > 0 "number of realizations must be positive"

    new(spatialdata, domain, targetvars, nreals)
  end
end

function SimulationProblem(spatialdata::S, domain::D, targetvarnames::Vector{Symbol}, nreals::Int
                          ) where {S<:AbstractSpatialData,D<:AbstractDomain}
  datavnames = [var for (var,T) in variables(spatialdata)]
  datacnames = [var for (var,T) in coordinates(spatialdata)]

  @assert targetvarnames ⊆ datavnames "target variables must be present in spatial data"
  @assert isempty(targetvarnames ∩ datacnames) "target variables can't be coordinates"
  @assert ndims(domain) == length(datacnames) "data and domain must have the same number of dimensions"

  # build dictionary of target variables
  datavars = variables(spatialdata)
  targetvars = Dict(var => T for (var,T) in datavars if var ∈ targetvarnames)

  SimulationProblem{S,D}(spatialdata, domain, targetvars, nreals)
end

SimulationProblem(spatialdata::S, domain::D, targetvarname::Symbol,
                  nreals::Int) where {S<:AbstractSpatialData,D<:AbstractDomain} =
  SimulationProblem(spatialdata, domain, [targetvarname], nreals)

function SimulationProblem(domain::D, targetvars::Dict{Symbol,DataType},
                           nreals::Int) where {D<:AbstractDomain}

  SimulationProblem{Void,D}(nothing, domain, targetvars, nreals)
end

SimulationProblem(domain::D, targetvar::Pair{Symbol,DataType},
                  nreals::Int) where {D<:AbstractDomain} =
  SimulationProblem(domain, Dict(targetvar), nreals)

"""
    data(problem)

Return the spatial data of the simulation `problem`.
"""
data(problem::SimulationProblem) = problem.spatialdata

"""
    domain(problem)

Return the spatial domain of the simulation `problem`.
"""
domain(problem::SimulationProblem) = problem.domain

"""
    variables(problem)

Return the target variables of the simulation `problem` and their types.
"""
variables(problem::SimulationProblem) = problem.targetvars

"""
    coordinates(problem)

Return the name of the coordinates of the simulation `problem` and their types.
"""
function coordinates(problem::SimulationProblem)
  if problem.spatialdata ≠ nothing
    coordinates(problem.spatialdata)
  else
    T = coordtype(problem.domain)
    Dict("x$i" => T for i=1:ndims(problem.domain))
  end
end

"""
    hasdata(problem)

Return `true` if simulation `problem` has data.
"""
hasdata(problem::SimulationProblem) = (problem.spatialdata ≠ nothing &&
                                       npoints(problem.spatialdata) > 0)

"""
    nreals(problem)

Return the number of realizations of the simulation `problem`.
"""
nreals(problem::SimulationProblem) = problem.nreals

# ------------
# IO methods
# ------------
function Base.show(io::IO, problem::SimulationProblem)
  dim = ndims(problem.domain)
  kind = hasdata(problem) ? "conditional" : "unconditional"
  print(io, "$(dim)D SimulationProblem ($kind)")
end

function Base.show(io::IO, ::MIME"text/plain", problem::SimulationProblem)
  vars = ["$var ($T)" for (var,T) in problem.targetvars]
  println(io, problem)
  println(io, "  data:      ", problem.spatialdata)
  println(io, "  domain:    ", problem.domain)
  println(io, "  variables: ", join(vars, ", ", " and "))
  print(  io, "  N° reals:  ", problem.nreals)
end
