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
  geodata::GeoData
  domain::D
  targetvars::Vector{Symbol}

  function EstimationProblem{D}(geodata, domain, targetvars) where {D<:AbstractDomain}
    @assert targetvars ⊆ names(geodata) "target variables must be columns of geodata"
    @assert isempty(targetvars ∩ coordnames(geodata)) "target variables can't be coordinates"
    new(geodata, domain, targetvars)
  end
end

EstimationProblem(geodata, domain, targetvars) =
  EstimationProblem{typeof(domain)}(geodata, domain, targetvars)

# ------------
# IO methods
# ------------
function Base.show(io::IO, ::MIME"text/plain", problem::EstimationProblem{D}) where {D<:AbstractDomain}
  println(io, "EstimationProblem:")
  println(io, "  data:      ", problem.geodata)
  println(io, "  domain:    ", problem.domain)
  println(io, "  variables: ", join(problem.targetvars, ", ", " and "))
end
