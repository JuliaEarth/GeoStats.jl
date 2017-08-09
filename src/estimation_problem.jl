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
    EstimationProblem(domain, geodata, targetvars)

A spatial estimation problem on a given `domain` in which the
variables to be estimated are listed in `targetvars`. The
data of the problem is stored in `geodata`.
"""
struct EstimationProblem{D<:AbstractDomain} <: AbstractProblem
  domain::D
  geodata::GeoData
  targetvars::Vector{Symbol}

  function EstimationProblem{D}(domain, geodata, targetvars) where {D<:AbstractDomain}
    @assert targetvars ⊆ names(geodata) "target variables must be columns of geodata"
    @assert isempty(targetvars ∩ coordnames(geodata)) "target variables can't be coordinates"
    new(domain, geodata, targetvars)
  end
end

EstimationProblem(domain, geodata, targetvars) =
  EstimationProblem{typeof(domain)}(domain, geodata, targetvars)

# ------------
# IO methods
# ------------
function Base.show(io::IO, ::MIME"text/plain", problem::EstimationProblem{D}) where {D<:AbstractDomain}
  println(io, "EstimationProblem:")
  println(io, "  domain:    ", problem.domain)
  println(io, "  geodata:   ", problem.geodata)
  println(io, "  variables: ", join(problem.targetvars, ", ", " and "))
end
