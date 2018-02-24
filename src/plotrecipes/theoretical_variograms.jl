# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@recipe function f(γ::AbstractVariogram; maxlag=3.)
  # discretize
  h = linspace(0, maxlag, 100)

  seriestype --> :path
  xlabel --> "Lag h"
  ylabel --> "Variogram(h)"
  label --> "variogram"

  h, γ(h)
end
