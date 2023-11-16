# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

# type alias to reduce typing
const V{T} = AbstractVector{<:T}

ascolors(values::V{CategoricalValue}, scheme) = scheme[levelcode.(values)]
ascolors(values::V{Quantity}, scheme) = ascolors(ustrip.(values), scheme)
ascolors(values::V{DateTime}, scheme) = ascolors(datetime2unix.(values), scheme)
ascolors(values::V{Date}, scheme) = ascolors(convert.(Ref(DateTime), values), scheme)

function defaultscheme(values::CategoricalArray)
  nlevels = length(levels(values))
  cgrad(:Set3_9, nlevels > 2 ? nlevels : 2, categorical=true)
end
