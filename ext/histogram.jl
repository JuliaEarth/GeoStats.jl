# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENCE in the project root.
# ------------------------------------------------------------------

Makie.plottype(::EmpiricalHistogram) = Makie.Hist

Makie.convert_arguments(P::Type{<:Makie.Hist}, h::EmpiricalHistogram) = Makie.convert_arguments(P, h.hist)
