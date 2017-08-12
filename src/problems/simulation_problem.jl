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
    SimulationProblem(geodata, domain, targetvars)

A spatial simulation problem on a given `domain` in which the
variables to be estimated are listed in `targetvars`. The
data of the problem is stored in `geodata`.
"""
struct SimulationProblem{D<:AbstractDomain} <: AbstractProblem
  geodata::GeoDataFrame
  domain::D
  targetvars::Vector{Symbol}

  function SimulationProblem{D}(geodata, domain, targetvars) where {D<:AbstractDomain}
    @assert targetvars ⊆ names(data(geodata)) "target variables must be columns of geodata"
    @assert isempty(targetvars ∩ coordnames(geodata)) "target variables can't be coordinates"
    @assert ndims(domain) == length(coordnames(geodata)) "data and domain must have the same number of dimensions"

    new(geodata, domain, targetvars)
  end
end

SimulationProblem(geodata, domain, targetvars) =
  SimulationProblem{typeof(domain)}(geodata, domain, targetvars)

SimulationProblem(geodata, domain, targetvar::Symbol) =
  SimulationProblem(geodata, domain, [targetvar])

"""
    SimulationSolution

A solution to a spatial simulation problem.
"""
struct SimulationSolution{D<:AbstractDomain} <: AbstractSolution
  domain::D
  realizations::Dict{Symbol,Vector{Vector}}
end

SimulationSolution(domain, realizations) =
  SimulationSolution{typeof(domain)}(domain, realizations)

# ------------
# IO methods
# ------------
function Base.show(io::IO, problem::SimulationProblem{D}) where {D<:AbstractDomain}
  dim = ndims(problem.domain)
  print(io, "$(dim)D SimulationProblem")
end

function Base.show(io::IO, ::MIME"text/plain", problem::SimulationProblem{D}) where {D<:AbstractDomain}
  println(io, problem)
  println(io, "  data:      ", problem.geodata)
  println(io, "  domain:    ", problem.domain)
  print(  io, "  variables: ", join(problem.targetvars, ", ", " and "))
end
