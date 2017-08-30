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
  targetvars::Dict{Symbol,DataType}

  function EstimationProblem{S,D}(spatialdata, domain, targetvars) where {S<:AbstractSpatialData,D<:AbstractDomain}
    probvnames = keys(targetvars)
    datavnames = [var for (var,T) in variables(spatialdata)]
    datacnames = [var for (var,T) in coordinates(spatialdata)]

    @assert !isempty(probvnames) "target variables must be specified"
    @assert probvnames ⊆ datavnames "target variables must be present in spatial data"
    @assert isempty(probvnames ∩ datacnames) "target variables can't be coordinates"
    @assert ndims(domain) == length(datacnames) "data and domain must have the same number of dimensions"

    new(spatialdata, domain, targetvars)
  end
end

function EstimationProblem(spatialdata::S, domain::D, targetvarnames::Vector{Symbol}
                          ) where {S<:AbstractSpatialData,D<:AbstractDomain}
  # build dictionary of target variables
  datavars = variables(spatialdata)
  targetvars = Dict(var => T for (var,T) in datavars if var ∈ targetvarnames)

  EstimationProblem{S,D}(spatialdata, domain, targetvars)
end

EstimationProblem(spatialdata::S, domain::D, targetvarname::Symbol
                 ) where {S<:AbstractSpatialData,D<:AbstractDomain} =
  EstimationProblem(spatialdata, domain, [targetvarname])

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

Return the variable names of the estimation `problem` and their types.
"""
variables(problem::EstimationProblem) = problem.targetvars

"""
    coordinates(problem)

Return the name of the coordinates of the estimation `problem` and their types.
"""
coordinates(problem::EstimationProblem) = coordinates(problem.spatialdata)

# ------------
# IO methods
# ------------
function Base.show(io::IO, problem::EstimationProblem)
  dim = ndims(problem.domain)
  print(io, "$(dim)D EstimationProblem")
end

function Base.show(io::IO, ::MIME"text/plain", problem::EstimationProblem)
  vars = ["$var ($T)" for (var,T) in problem.targetvars]
  println(io, problem)
  println(io, "  data:      ", problem.spatialdata)
  println(io, "  domain:    ", problem.domain)
  print(  io, "  variables: ", join(vars, ", ", " and "))
end
