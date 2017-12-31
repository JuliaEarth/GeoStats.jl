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

@userplot HScatter

@recipe function f(hs::HScatter; lag=1., tol=1e-1, distance=Euclidean())
  # get inputs
  spatialdata = hs.args[1]
  var₁ = hs.args[2]
  var₂ = length(hs.args) == 3 ? hs.args[3] : var₁

  X₁, z₁ = valid(spatialdata, var₁)
  X₂, z₂ = valid(spatialdata, var₂)

  inds = Vector{Tuple{Int,Int}}()
  for i in 1:size(X₁, 2)
    xi = view(X₁, :, i)
    for j in 1:size(X₂, 2)
      xj = view(X₂, :, j)
      h = evaluate(distance, xi, xj)
      abs(h - lag) < tol && push!(inds, (i,j))
    end
  end

  x = z₁[first.(inds)]
  y = z₂[last.(inds)]

  # plot identity line
  @series begin
    seriestype := :path
    primary := false
    linestyle := :dash
    color := :black

    xmin, xmax = extrema(x)
    ymin, ymax = extrema(y)
    vmin = min(xmin, ymin)
    vmax = max(xmax, ymax)

    [vmin, vmax], [vmin, vmax]
  end

  seriestype := :scatter
  xlabel := var₁
  ylabel := var₂
  label --> @sprintf "h-scatter (corr = %.2f)" cor(x, y)

  x, y
end
