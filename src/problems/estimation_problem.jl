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
    EstimationProblem(spatialdata, domain, targetvars)

A spatial estimation problem on a given `domain` in which the
variables to be estimated are listed in `targetvars`. The
data of the problem is stored in `spatialdata`.
"""
struct EstimationProblem{S<:AbstractSpatialData,D<:AbstractDomain} <: AbstractProblem
  spatialdata::S
  domain::D
  targetvars::Vector{Symbol}

  function EstimationProblem{S,D}(spatialdata, domain, targetvars) where {S<:AbstractSpatialData,D<:AbstractDomain}
    @assert targetvars ⊆ names(data(spatialdata)) "target variables must be present in spatial data"
    @assert isempty(targetvars ∩ coordnames(spatialdata)) "target variables can't be coordinates"
    @assert ndims(domain) == length(coordnames(spatialdata)) "data and domain must have the same number of dimensions"

    new(spatialdata, domain, targetvars)
  end
end

EstimationProblem(spatialdata::S, domain::D, targetvars::Vector{Symbol}
                 ) where {S<:AbstractSpatialData,D<:AbstractDomain} =
  EstimationProblem{S,D}(spatialdata, domain, targetvars)

EstimationProblem(spatialdata::S, domain::D, targetvar::Symbol
                 ) where {S<:AbstractSpatialData,D<:AbstractDomain} =
  EstimationProblem(spatialdata, domain, [targetvar])

"""
    data(problem)

Return the spatial data of the estimation `problem`.
"""
data(problem::EstimationProblem) = problem.spatialdata

"""
    domain(problem)

Return the spatial domain of the estimation `problem`.
"""
domain(problem::EstimationProblem) = problem.domain

"""
    variables(problem)

Return the target variables of the estimation `problem`.
"""
variables(problem::EstimationProblem) = problem.targetvars

# ------------
# IO methods
# ------------
function Base.show(io::IO, problem::EstimationProblem)
  dim = ndims(problem.domain)
  print(io, "$(dim)D EstimationProblem")
end

function Base.show(io::IO, ::MIME"text/plain", problem::EstimationProblem)
  println(io, problem)
  println(io, "  data:      ", problem.spatialdata)
  println(io, "  domain:    ", problem.domain)
  print(  io, "  variables: ", join(problem.targetvars, ", ", " and "))
end
