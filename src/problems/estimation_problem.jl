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
    EstimationProblem(geodata, domain, targetvars)

A spatial estimation problem on a given `domain` in which the
variables to be estimated are listed in `targetvars`. The
data of the problem is stored in `geodata`.
"""
struct EstimationProblem{D<:AbstractDomain} <: AbstractProblem
  geodata::GeoDataFrame
  domain::D
  targetvars::Vector{Symbol}

  function EstimationProblem{D}(geodata, domain, targetvars) where {D<:AbstractDomain}
    @assert targetvars ⊆ names(data(geodata)) "target variables must be columns of geodata"
    @assert isempty(targetvars ∩ coordnames(geodata)) "target variables can't be coordinates"
    @assert ndims(domain) == length(coordnames(geodata)) "data and domain must have the same number of dimensions"

    new(geodata, domain, targetvars)
  end
end

EstimationProblem(geodata::GeoDataFrame, domain::D,
                  targetvars::Vector{Symbol}) where {D<:AbstractDomain} =
  EstimationProblem{D}(geodata, domain, targetvars)

EstimationProblem(geodata::GeoDataFrame, domain::D,
                  targetvar::Symbol) where {D<:AbstractDomain} =
  EstimationProblem(geodata, domain, [targetvar])

# ------------
# IO methods
# ------------
function Base.show(io::IO, problem::EstimationProblem{D}) where {D<:AbstractDomain}
  dim = ndims(problem.domain)
  print(io, "$(dim)D EstimationProblem")
end

function Base.show(io::IO, ::MIME"text/plain", problem::EstimationProblem{D}) where {D<:AbstractDomain}
  println(io, problem)
  println(io, "  data:      ", problem.geodata)
  println(io, "  domain:    ", problem.domain)
  print(  io, "  variables: ", join(problem.targetvars, ", ", " and "))
end
