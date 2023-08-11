# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

function viewer(data::Data; kwargs...)
  # retrieve domain and element table
  dom, tab = domain(data), values(data)

  # list of all variables
  cols = Tables.columns(tab)
  vars = Tables.columnnames(cols)

  # list of viewable variables
  viewable = filter(vars) do var
    v = Tables.getcolumn(cols, var)
    isviewable(elscitype(v))
  end

  # throw error if there are no viewable variables
  if isempty(viewable)
    throw(AssertionError("""
      Could not find viewable variables.
      Please make sure that the scientific type of columns is correct.
      A common mistake is to try to plot a textual column `col` directly.
      The textual column must be coerced to `Multiclass` or `OrderedFactor`.
      For example, `table |> Coerce(:col => Multiclass)`.
      """))
  end

  # initialize figure and menu
  fig    = Makie.Figure()
  label  = Makie.Label(fig[1,1], "Variable")
  menu   = Makie.Menu(fig[1,2], options = collect(viewable))

  # select viewable variable
  var  = menu.selection
  vals = Makie.@lift Tables.getcolumn(cols, $var)
  cmap = Makie.@lift defaultscheme($vals)
  lims = Makie.@lift extrema($vals)

  # initialize visualization
  viz(fig[2,:], dom; color = vals, kwargs...)
  Makie.Colorbar(fig[2,3], colormap = cmap, limits = lims)

  # update visualization if necessary
  Makie.on(menu.selection) do var
    vals[] = Tables.getcolumn(cols, var)
  end

  fig
end

isviewable(::Type) = false
isviewable(::Type{<:Finite}) = true
isviewable(::Type{<:Infinite}) = true
isviewable(::Type{<:Unknown}) = true
