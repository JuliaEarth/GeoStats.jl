# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@recipe function f(solution::SimulationSolution{<:RegularGrid}; variables=nothing)
  # grid dimension and size
  sdomain = domain(solution)
  dim = ndims(sdomain)
  sz  = size(sdomain)
  or  = origin(sdomain)
  sp  = spacing(sdomain)

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
  inds = sample(1:nreals, N, replace=false)

  for (i,var) in enumerate(variables)
    reals = solution.realizations[var][inds]

    # find value limits across realizations
    minmax = extrema.(reals)
    vmin = minimum(first.(minmax))
    vmax = maximum(last.(minmax))

    for (j,real) in enumerate(reals)
      # results in grid format
      R = reshape(real, sz)

      if dim == 1 # plot a line
        x = or[1]:sp[1]:or[1]+(sz[1]-1)*sp[1]
        @series begin
          subplot := (i-1)*N + j
          seriestype := :path
          legend := false
          title --> string(var, " $j")
          x, R
        end
      elseif dim == 2 # plot a heat map
        @series begin
          subplot := (i-1)*N + j
          seriestype := :heatmap
          seriescolor --> :bluesreds
          clims --> (vmin, vmax)
          title --> string(var, " $j")
          flipdim(rotr90(R), 2)
        end
      elseif dim == 3 # plot a volume
        @series begin
          subplot := (i-1)*N + j
          seriestype := :volume
          seriescolor --> :bluesreds
          clims --> (vmin, vmax)
          title --> string(var, " $j")
          R
        end
      else
        error("cannot plot solution in more than 3 dimensions")
      end
    end
  end
end
