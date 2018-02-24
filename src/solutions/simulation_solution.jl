# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

function digest(solution::SimulationSolution{<:RegularGrid})
  # solution variables
  variables = collect(keys(solution.realizations))

  # get the size of the grid
  sz = size(solution.domain)

  # build dictionary pairs
  pairs = []
  for var in variables
    reals = map(r -> reshape(r, sz), solution.realizations[var])
    push!(pairs, var => reals)
  end

  # output dictionary
  Dict(pairs)
end
