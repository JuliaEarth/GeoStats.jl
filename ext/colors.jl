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
defaultscheme(::Type{Unknown}) = cgrad(:viridis)
defaultscheme(::Type{Continuous}) = cgrad(:viridis)
defaultscheme(::Type{Count}) = cgrad(:viridis)
defaultscheme(::Type{Multiclass{N}}) where {N} =
  cgrad(:Spectral, N, categorical=true)
defaultscheme(::Type{OrderedFactor{N}}) where {N} =
  cgrad(:Spectral, N, categorical=true)
defaultscheme(::Type{ScientificDateTime}) = cgrad(:viridis)