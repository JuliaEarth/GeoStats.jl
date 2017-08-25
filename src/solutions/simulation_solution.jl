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
    Realization(var1 => values1, var2 => values2, ...)

A realization of the variables `var1`, `var2`, ... where
the simulated values are stored in one-dimensional vectors
`values1`, `values2`, ...

### Notes

A `Realization` is simply a Julia `Dict{Symbol,Vector}`.
"""
const Realization = Dict{Symbol,Vector}

"""
    SimulationSolution

A solution to a spatial simulation problem.
"""
struct SimulationSolution{D<:AbstractDomain} <: AbstractSolution
  domain::D
  realizations::Vector{Realization}
end

SimulationSolution(domain, realizations) =
  SimulationSolution{typeof(domain)}(domain, realizations)

function digest(solution::SimulationSolution{<:RegularGrid})
  # get the size of the grid
  sdomain = domain(solution)
  sz = size(sdomain)

  # solution variables and number of realizations
  variables = keys(solution.realizations[1])
  nreals = length(solution.realizations)

  # output dictionary
  digested = Dict{Symbol,Vector{Array}}()
  for var in variables
    reals = []
    for i=1:nreals
      real = reshape(solution.realizations[i][var], sz)
      push!(reals, real)
    end

    push!(digested, var => reals)
  end

  digested
end

# ------------
# IO methods
# ------------
function Base.show(io::IO, solution::SimulationSolution)
  dim = ndims(solution.domain)
  print(io, "$(dim)D SimulationSolution")
end

function Base.show(io::IO, ::MIME"text/plain", solution::SimulationSolution)
  println(io, solution)
  println(io, "  domain: ", solution.domain)
  print(  io, "  variables: ", join(keys(solution.realizations[1]), ", ", " and "))
end
