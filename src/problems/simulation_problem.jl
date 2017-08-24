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
    SimulationProblem(geodata, domain, targetvars, nreals)
    SimulationProblem(domain, targetvars, nreals)

A spatial simulation problem on a given `domain` in which the
variables to be simulated are listed in `targetvars`. For
conditional simulation, the data of the problem is stored in
`geodata`. In both cases, a number `nreals` of realizations
is requested.

### Notes

For unconditional simulation, an empty `geodata` object is
automatically created by the constructor. Therefore, all
simulation solvers can assume that a valid (possibly empty)
[`GeoDataFrame`](@ref) exists. To check if a problem has
data use the [`hasdata`](@ref) method.
"""
struct SimulationProblem{D<:AbstractDomain} <: AbstractProblem
  geodata::GeoDataFrame
  domain::D
  targetvars::Vector{Symbol}
  nreals::Int

  function SimulationProblem{D}(geodata, domain, targetvars, nreals) where {D<:AbstractDomain}
    @assert targetvars ⊆ names(data(geodata)) "target variables must be columns of geodata"
    @assert isempty(targetvars ∩ coordnames(geodata)) "target variables can't be coordinates"
    @assert ndims(domain) == length(coordnames(geodata)) "data and domain must have the same number of dimensions"
    @assert nreals > 0 "number of realizations must be positive"

    new(geodata, domain, targetvars, nreals)
  end
end

SimulationProblem(geodata::GeoDataFrame, domain::D, targetvars::Vector{Symbol},
                  nreals::Int) where {D<:AbstractDomain} =
  SimulationProblem{D}(geodata, domain, targetvars, nreals)

SimulationProblem(geodata::GeoDataFrame, domain::D, targetvar::Symbol,
                  nreals::Int) where {D<:AbstractDomain} =
  SimulationProblem(geodata, domain, [targetvar], nreals)

function SimulationProblem(domain::D, targetvars::Vector{Symbol},
                           nreals::Int) where {D<:AbstractDomain}
  dim = ndims(domain)
  ctypes = [coordtype(domain) for i=1:dim]
  vtypes = [Float64 for i=1:length(targetvars)]
  cnames = [Symbol("x$i") for i=1:dim]
  vnames = targetvars
  nodata = DataFrame([ctypes...,vtypes...], [cnames...,vnames...], 0)

  geodata = GeoDataFrame(nodata, cnames)

  SimulationProblem(geodata, domain, targetvars, nreals)
end

SimulationProblem(domain::D, targetvar::Symbol,
                  nreals::Int) where {D<:AbstractDomain} =
  SimulationProblem(domain, [targetvar], nreals)

"""
    nreals(simproblem)

Return the number of realizations of the simulation problem `simproblem`.
"""
nreals(problem::SimulationProblem) = problem.nreals

# ------------
# IO methods
# ------------
function Base.show(io::IO, problem::SimulationProblem{D}) where {D<:AbstractDomain}
  dim = ndims(problem.domain)
  kind = hasdata(problem) ? "conditional" : "unconditional"
  print(io, "$(dim)D SimulationProblem ($kind)")
end

function Base.show(io::IO, ::MIME"text/plain", problem::SimulationProblem{D}) where {D<:AbstractDomain}
  println(io, problem)
  println(io, "  data:      ", problem.geodata)
  println(io, "  domain:    ", problem.domain)
  println(io, "  variables: ", join(problem.targetvars, ", ", " and "))
  print(  io, "  N° reals:  ", problem.nreals)
end
