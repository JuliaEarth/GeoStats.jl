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

@recipe function f(solution::SimulationSolution{<:RegularGrid}; variables=nothing)
  # grid dimension and size
  sdomain = domain(solution)
  dim = ndims(sdomain)
  sz  = size(sdomain)

  # valid variables
  validvars = sort(collect(keys(solution.realizations)))

  # plot all variables by default
  variables == nothing && (variables = validvars)
  @assert variables ⊆ validvars "invalid variable name"

  # number of realizations
  nreals = length(solution.realizations[variables[1]])

  # plot layout: at most 3 realizations per variable
  N = min(nreals, 3)
  layout := (length(variables), N)

  # select realizations at random
  reals = sample(1:nreals, N, replace=false)

  for (i,var) in enumerate(variables), j=1:N
    # select a realization at random
    real = solution.realizations[var][reals[j]]

    # results in grid format
    R = reshape(real, sz)

    if dim == 1 # plot a line
      @series begin
        subplot := (i-1)*N + j
        seriestype := :path
        legend := false
        title := string(var, " $j")
        R
      end
    elseif dim == 2 # plot a heat map
      @series begin
        subplot := (i-1)*N + j
        seriestype := :heatmap
        title := string(var, " $j")
        color --> :bluesreds
        flipdim(rotr90(R), 2)
      end
    elseif dim == 3 # plot a volume
      @series begin
        subplot := (i-1)*N + j
        seriestype := :volume
        title := string(var, " $j")
        color --> :bluesreds
        R
      end
    else
      error("cannot plot solution in more than 3 dimensions")
    end
  end
end
