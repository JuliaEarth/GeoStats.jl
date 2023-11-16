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

  # constant variables
  isconst = map(viewable) do var
    vals = Tables.getcolumn(cols, var)
    var => allequal(vals)
  end |> Dict

  # list of menu options
  options = map(viewable) do var
    if isconst[var]
      vals = Tables.getcolumn(cols, var)
      v = asstring(first(vals))
      "$var = $v (constant)"
    else
      string(var)
    end
  end |> collect

  # map menu option to corresponding variable
  optmap = Dict(zip(options, viewable))

  # initialize figure and menu
  fig = Makie.Figure()
  Makie.Label(fig[1, 1], "Variable")
  menu = Makie.Menu(fig[1, 2], options=options)

  # select first viewable variable
  var = first(viewable)

  # initialize observables
  vals = Makie.Observable{Any}()
  cmap = Makie.Observable{Any}()
  lims = Makie.Observable{Any}()
  ticks = Makie.Observable{Any}()
  format = Makie.Observable{Any}()
  vals[] = Tables.getcolumn(cols, var) |> asvalues

  # initialize visualization
  Makie.plot(fig[2, :], dom; color=vals, kwargs...)

  # initialize Colorbar
  cbar = if !isconst[var]
    cmap[] = defaultscheme(vals[])
    lims[] = defaultlimits(vals[])
    ticks[] = defaultticks(vals[])
    format[] = defaultformat(vals[])
    Makie.Colorbar(fig[2, 3], colormap=cmap, limits=lims, ticks=ticks, tickformat=format)
  else
    nothing
  end

  # update visualization if necessary
  Makie.on(menu.selection) do opt
    var = optmap[opt]
    vals[] = Tables.getcolumn(cols, var) |> asvalues
    if !isconst[var]
      cmap[] = defaultscheme(vals[])
      lims[] = defaultlimits(vals[])
      ticks[] = defaultticks(vals[])
      format[] = defaultformat(vals[])
      if isnothing(cbar)
        cbar = Makie.Colorbar(fig[2, 3], colormap=cmap, limits=lims, ticks=ticks, tickformat=format)
      end
    else
      if !isnothing(cbar)
        delete!(cbar)
        cbar = nothing
      end
    end
  end

  fig
end

defaultlimits(vals) = asfloat.(extrema(skipmissing(vals)))
defaultlimits(vals::CategoricalArray) = (0.0, asfloat(length(levels(vals))))

defaultticks(vals) = range(defaultlimits(vals)..., 5)
defaultticks(vals::CategoricalArray) = 0:length(levels(vals))

defaultformat(vals::CategoricalArray) = ticks -> map(t -> asstring(t, levels(vals)), ticks)
function defaultformat(vals)
  T = nonmissingtype(eltype(vals))
  if T <: AbstractQuantity
    u = unit(T)
    ticks -> map(t -> asstring(t) * " " * asstring(u), ticks)
  else
    ticks -> map(asstring, ticks)
  end
end

asvalues(x) = asvalues(nonmissingtype(eltype(x)), x)
asvalues(::Type, x) = elscitype(x) <: Categorical ? ascateg(x) : x
asvalues(::Type{<:Colorant}, x) = map(c -> ismissing(c) ? missing : Float64(Gray(c)), x)

ascateg(x) = categorical(x)
ascateg(x::CategoricalArray) = x

asfloat(x) = float(x)
asfloat(x::Quantity) = float(ustrip(x))

function asstring(tick, levels)
  i = trunc(Int, tick)
  isassigned(levels, i) ? asstring(levels[i]) : ""
end

asstring(x) = repr(x, context=:compact => true)

isviewable(::Type) = false
isviewable(::Type{Categorical}) = true
isviewable(::Type{Continuous}) = true
isviewable(::Type{Unknown}) = true
