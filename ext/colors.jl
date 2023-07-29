# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

# type alias to reduce typing
const V{T} = AbstractVector{<:T}

ascolors(values::V{CategoricalValue}, scheme) = scheme[levelcode.(values)]
ascolors(values::V{Quantity}, scheme) = ascolors(ustrip.(values), scheme)
ascolors(values::V{DateTime}, scheme) = ascolors(datetime2unix.(values), scheme)
ascolors(values::V{Date}, scheme) = ascolors(convert.(Ref(DateTime), values), scheme)

defaultscheme(values::V) = defaultscheme(elscitype(values))
defaultscheme(::Type{Unknown}) = colorschemes[:viridis]
defaultscheme(::Type{Continuous}) = colorschemes[:viridis]
defaultscheme(::Type{Count}) = colorschemes[:viridis]
defaultscheme(::Type{Multiclass{N}}) where {N} =
  distinguishable_colors(N, transform=protanopic)
defaultscheme(::Type{OrderedFactor{N}}) where {N} =
  distinguishable_colors(N, transform=protanopic)
defaultscheme(::Type{ScientificDateTime}) = colorschemes[:viridis]