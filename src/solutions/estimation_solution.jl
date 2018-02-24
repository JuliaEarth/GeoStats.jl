# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

function digest(solution::EstimationSolution{<:RegularGrid})
  # solution variables
  variables = keys(solution.mean)

  # get the size of the grid
  sz = size(solution.domain)

  # build dictionary pairs
  pairs = []
  for var in variables
    M = reshape(solution.mean[var], sz)
    V = reshape(solution.variance[var], sz)

    push!(pairs, var => Dict(:mean => M, :variance => V))
  end

  # output dictionary
  Dict(pairs)
end
