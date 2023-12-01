# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

# type alias to reduce typing
const V{T} = AbstractVector{<:T}

function ascolors(values::V{Distribution}, scheme)
  colors = ascolors(location.(values), scheme)
  alphas = let
    s = scale.(values)
    a, b = extrema(s)
    if a == b
      fill(1, length(values))
    else
      @. 1 - (s - a) / (b - a)
    end
  end
  coloralpha.(colors, alphas)
end

ascolors(values::V{CategoricalValue}, scheme) = scheme[levelcode.(values)]

ascolors(values::V{Quantity}, scheme) = ascolors(ustrip.(values), scheme)

ascolors(values::V{DateTime}, scheme) = ascolors(datetime2unix.(values), scheme)

ascolors(values::V{Date}, scheme) = ascolors(convert.(Ref(DateTime), values), scheme)

function defaultscheme(values::CategArray)
  nlevels = length(levels(values))
  cgrad(:Set3_9, nlevels > 2 ? nlevels : 2, categorical=true)
end
