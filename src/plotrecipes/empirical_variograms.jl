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

@recipe function f(γ::EmpiricalVariogram; bincounts=true)
  # get the data
  x, y, n = values(γ)

  # discard empty bins
  x = x[n .> 0]; y = y[n .> 0]; n = n[n .> 0]

  # draw bin counts as a measure of confidence
  if bincounts
    @series begin
      # plot a "frequency" instead of raw counts
      f = n*(maximum(y) / maximum(n)) / 10.

      seriestype := :bar
      fillalpha := .5
      color := :blue
      label := "bin counts"

      x, f
    end
  end

  seriestype := :scatter
  xlim := (0, γ.maxlag)
  color --> :orange
  xlabel --> "Lag h"
  ylabel --> "Variogram(h)"
  label --> "variogram"

  x, y
end
