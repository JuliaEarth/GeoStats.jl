# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@userplot HScatter

@recipe function f(hs::HScatter; lags=nothing, tol=1e-1, distance=Euclidean())
  # get inputs
  spatialdata = hs.args[1]
  var₁ = hs.args[2]
  var₂ = length(hs.args) == 3 ? hs.args[3] : var₁

  # lookup valid data
  X₁, z₁ = valid(spatialdata, var₁)
  X₂, z₂ = valid(spatialdata, var₂)

  # compute pairwise distance
  m, n = length(z₁), length(z₂)
  ds = [evaluate(distance, view(X₁,:,i), view(X₂,:,j)) for j in 1:n for i in j:m]
  inds = [sub2ind((m, n), i, j) for j in 1:n for i in j:m]

  # use quartiles by default
  lags == nothing && (lags = quantile(ds, [.00,.25,.50,.75]))

  xlabel := var₁
  ylabel := var₂
  legend := false
  aspect_ratio := :equal
  layout --> (1, length(lags))

  for (i, lag) in enumerate(lags)
    # find indices with given lag
    match = find(abs.(ds - lag) .< tol)

    if isempty(match)
      warn("no points were found with lag = $lag, skipping...")
      continue
    end

    # scatter plot coordinates
    ind₁, ind₂ = ind2sub((m, n), inds[match])
    x, y = z₁[ind₁], z₂[ind₂]

    # plot identity line
    @series begin
      subplot := i
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

    # plot h-scatter
    @series begin
      subplot := i
      seriestype := :scatter
      title --> @sprintf "h = %.1f, corr = %.2f" lag cor(x, y)

      x, y
    end
  end
end
