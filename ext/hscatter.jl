# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

Makie.@recipe(HScatter, data, var₁, var₂) do scene
  Makie.Attributes(;
    # h-scatter options
    lag           = 0.0,
    tol           = 1e-1,
    distance      = Euclidean(),

    # aesthetics options
    size        = 2,
    color       = :slategray,
    alpha       = 1.0,
    colorscheme = :viridis,
    rcolor      = :maroon,
    icolor      = :black,
    ccolor      = :teal,
  )
end

function Makie.plot!(plot::HScatter)
  # retrieve data and variables
  data = plot[:data]
  var₁ = plot[:var₁]
  var₂ = plot[:var₂]

  # retrieve h-scatter options
  lag      = plot[:lag]
  tol      = plot[:tol]
  distance = plot[:distance]

  # h-scatter coordinates
  xy = Makie.@lift _hscatter($data, $var₁, $var₂, $lag, $tol, $distance)
  x = Makie.@lift $xy[1]
  y = Makie.@lift $xy[2]

  # visualizat h-scatter
  Makie.scatter!(plot, x, y,
    color      = plot[:color],
    colormap   = plot[:colorscheme],
    alpha      = plot[:alpha],
    markersize = plot[:size],
  )

  # visualize regression line
  ŷ = Makie.@lift let
    X = [$x ones(length($x))]
    X * (X \ $y)
  end
  Makie.lines!(plot, x, ŷ,
    color = plot[:rcolor],
  )

  # visualize identity line
  vv = Makie.@lift let
    xmin, xmax = extrema($x)
    ymin, ymax = extrema($y)
    vmin = min(xmin, ymin)
    vmax = max(xmax, ymax)
    [vmin, vmax]
  end
  Makie.lines!(plot, vv, vv,
    color = plot[:icolor],
  )

  # visualize center lines
  x̄ = Makie.@lift mean($x)
  ȳ = Makie.@lift mean($y)
  xx = Makie.@lift [$x̄, $x̄]
  yy = Makie.@lift [$ȳ, $ȳ]
  Makie.lines!(plot, xx, vv,
    color = plot[:ccolor],
  )
  Makie.lines!(plot, vv, yy,
    color = plot[:ccolor],
  )
  Makie.scatter!(plot, x̄, ȳ,
    color = plot[:ccolor],
    marker = :rect,
    markersize = 16,
  )
end

function _hscatter(data, var₁, var₂, lag, tol, distance)
  # lookup valid data
  𝒮₁ = view(data, findall(!ismissing, data[:,var₁]))
  𝒮₂ = view(data, findall(!ismissing, data[:,var₂]))
  𝒟₁ = domain(𝒮₁)
  𝒟₂ = domain(𝒮₂)
  x₁ = [coordinates(centroid(𝒟₁, i)) for i in 1:nelements(𝒟₁)]
  x₂ = [coordinates(centroid(𝒟₂, i)) for i in 1:nelements(𝒟₂)]
  z₁ = getproperty(𝒮₁, var₁)
  z₂ = getproperty(𝒮₂, var₂)

  # compute pairwise distance
  m, n = length(z₁), length(z₂)
  pairs = [(i,j) for j in 1:n for i in j:m]
  ds = [distance(x₁[i], x₂[j]) for (i, j) in pairs]

  # find indices with given lag
  match = findall(abs.(ds .- lag) .< tol)

  if isempty(match)
    throw(ErrorException("No points were found with lag = $lag, aborting..."))
  end

  # h-scatter coordinates
  mpairs = view(pairs, match)
  x = z₁[first.(mpairs)]
  y = z₂[last.(mpairs)]

  x, y
end
