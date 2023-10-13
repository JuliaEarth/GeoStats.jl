# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

function viewer(data::AbstractGeoTable; kwargs...)
  # retrieve domain and element table
  dom, tab = domain(data), values(data)

  # list of all variables
  cols = Tables.columns(tab)
  vars = Tables.columnnames(cols)

  # list of viewable variables
  viewable = filter(vars) do var
    vals = Tables.getcolumn(cols, var)
    isviewable(elscitype(vals))
  end

  # throw error if there are no viewable variables
  if isempty(viewable)
    throw(AssertionError("""
      Could not find viewable variables, i.e., variables that can be
      converted to colors with the `ascolors` trait. Please make sure
      that the scientific type of variables is correct.
      """))
  end

  # initialize figure and menu
  fig   = Makie.Figure()
  label = Makie.Label(fig[1,1], "Variable")
  menu  = Makie.Menu(fig[1,2], options = collect(viewable))

  # select first viewable variable
  var = first(viewable)

  # initialize observables
  vals = Makie.Observable{Any}()
  cmap = Makie.Observable{Any}()
  lims = Makie.Observable{Any}()
  ticks = Makie.Observable{Any}()
  format = Makie.Observable{Any}()
  vals[] = Tables.getcolumn(cols, var) |> asvalues
  cmap[] = defaultscheme(vals[])
  lims[] = defaultlimits(vals[])
  ticks[] = defaultticks(vals[])
  format[] = defaultformat(vals[])

  # initialize visualization
  Makie.plot(fig[2,:], dom; color=vals, kwargs...)
  Makie.Colorbar(fig[2,3], colormap=cmap, limits=lims, ticks=ticks, tickformat=format)

  # update visualization if necessary
  Makie.on(menu.selection) do var
    vals[] = Tables.getcolumn(cols, var) |> asvalues
    cmap[] = defaultscheme(vals[])
    lims[] = defaultlimits(vals[])
    ticks[] = defaultticks(vals[])
    format[] = defaultformat(vals[])
  end

  fig
end

defaultlimits(vals) = asfloat.(extrema(skipmissing(vals)))
defaultlimits(vals::CategoricalArray) = asfloat.((0, length(levels(vals))))

defaultticks(vals) = range(defaultlimits(vals)..., 5)
defaultticks(vals::CategoricalArray) = 0:length(levels(vals))

defaultformat(vals::CategoricalArray) = ticks -> map(t -> asstring(t, levels(vals)), ticks)
function defaultformat(vals)
  T = nonmissingtype(eltype(vals))
  if T <: AbstractQuantity
    u = unit(T)
    ticks -> map(t -> string(round(t, digits=2), " ", u), ticks)
  else
    ticks -> map(t -> string(round(t, digits=2)), ticks)
  end
end

asvalues(x) = asvalues(nonmissingtype(eltype(x)), x)
asvalues(::Type, x) = x
asvalues(::Type{<:Colorant}, x) = map(c -> Float64(Gray(c)), x)

asfloat(x) = float(x)
asfloat(x::AbstractQuantity) = float(ustrip(x))

function asstring(tick, levels)
  i = trunc(Int, tick)
  isassigned(levels, i) ? string(levels[i]) : ""
end

isviewable(::Type) = false
isviewable(::Type{SciTypes.Unknown}) = true
isviewable(::Type{SciTypes.Continuous}) = true
isviewable(::Type{SciTypes.Categorical}) = true
