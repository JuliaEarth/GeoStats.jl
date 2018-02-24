# ------------------------------------------------------------------
# Copyright (c) 2015, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    AbstractVariogram

A variogram model (e.g. Gaussian variogram).
"""
abstract type AbstractVariogram end

"""
    isstationary(γ)

Check if variogram `γ` possesses the 2nd-order stationary property.
"""
isstationary(::AbstractVariogram) = false

"""
    result_type(γ)

Return the result type of the variogram `γ`.
"""
result_type(::AbstractVariogram) = error("not implemented")

"""
    pairwise(γ, X)

Evaluate variogram `γ` between all n² pairs of columns in a
m-by-n matrix `X` efficiently.
"""
function pairwise(γ::AbstractVariogram, X::AbstractMatrix)
  m, n = size(X)
  Γ = zeros(result_type(γ), n, n)
  for j=1:n
    xj = view(X, :, j)
    for i=j+1:n
      xi = view(X, :, i)
      @inbounds Γ[i,j] = γ(xi, xj)
    end
    @inbounds Γ[j,j] = γ(xj, xj)
    for i=1:j-1
      @inbounds Γ[i,j] = Γ[j,i] # leverage the symmetry
    end
  end

  Γ
end

#------------------
# IMPLEMENTATIONS
#------------------
"""
    GaussianVariogram(sill=s, range=r, nugget=n, distance=d)

A Gaussian variogram with sill `s`, range `r` and nugget `n`.
Optionally, use a custom distance `d`.
"""
@with_kw struct GaussianVariogram{T<:Real,V,D<:Metric} <: AbstractVariogram
  range::T    = one(Float64)
  sill::V     = one(Float64)
  nugget::V   = zero(Float64)
  distance::D = Euclidean()
end
(γ::GaussianVariogram)(h) = (γ.sill - γ.nugget) * (1 - exp.(-3(h/γ.range).^2)) + γ.nugget
(γ::GaussianVariogram)(x, y) = γ(evaluate(γ.distance, x, y))
isstationary(::GaussianVariogram) = true
result_type(::GaussianVariogram{T,V,D}) where {T<:Real,V,D<:Metric} = promote_type(T, V)

"""
    ExponentialVariogram(sill=s, range=r, nugget=n, distance=d)

An exponential variogram with sill `s`, range `r` and nugget `n`.
Optionally, use a custom distance `d`.
"""
@with_kw struct ExponentialVariogram{T<:Real,V,D<:Metric} <: AbstractVariogram
  range::T    = one(Float64)
  sill::V     = one(Float64)
  nugget::V   = zero(Float64)
  distance::D = Euclidean()
end
(γ::ExponentialVariogram)(h) = (γ.sill - γ.nugget) * (1 - exp.(-3(h/γ.range))) + γ.nugget
(γ::ExponentialVariogram)(x, y) = γ(evaluate(γ.distance, x, y))
isstationary(::ExponentialVariogram) = true
result_type(::ExponentialVariogram{T,V,D}) where {T<:Real,V,D<:Metric} = promote_type(T, V)

"""
    MaternVariogram(sill=s, range=r, nugget=n, order=ν, distance=d)

A Matérn variogram with sill `s`, range `r` and nugget `n`. The parameter
ν is the order of the Bessel function. Optionally, use a custom distance `d`.
"""
@with_kw struct MaternVariogram{T<:Real,V,D<:Metric} <: AbstractVariogram
  range::T    = one(Float64)
  sill::V     = one(Float64)
  nugget::V   = zero(Float64)
  order::T    = one(Float64)
  distance::D = Euclidean()
end
(γ::MaternVariogram)(h) = begin
  s = γ.sill
  r = γ.range
  n = γ.nugget
  ν = γ.order

  # shift lag by machine precision to
  # avoid explosion at the origin
  h2 = h + eps(eltype(h))
  h3 = sqrt.(2.0ν)h2/r

  (s - n) * (1 - 2.0^(1 - ν)/gamma(ν) * h3.^ν .* besselk.(ν, h3)) + n
end
(γ::MaternVariogram)(x, y) = γ(evaluate(γ.distance, x, y))
isstationary(::MaternVariogram) = true
result_type(::MaternVariogram{T,V,D}) where {T<:Real,V,D<:Metric} = promote_type(T, V)

"""
    SphericalVariogram(sill=s, range=r, nugget=n, distance=d)

A spherical variogram with sill `s`, range `r` and nugget `n`.
Optionally, use a custom distance `d`.
"""
@with_kw struct SphericalVariogram{T<:Real,V,D<:Metric} <: AbstractVariogram
  range::T    = one(Float64)
  sill::V     = one(Float64)
  nugget::V   = zero(Float64)
  distance::D = Euclidean()
end
(γ::SphericalVariogram)(h) = begin
  s = γ.sill
  r = γ.range
  n = γ.nugget

  (h .< r) .* (s - n) .* (1.5(h/r) - 0.5(h/r).^3) + (h .≥ r) .* (s - n) + n
end
(γ::SphericalVariogram)(x, y) = γ(evaluate(γ.distance, x, y))
isstationary(::SphericalVariogram) = true
result_type(::SphericalVariogram{T,V,D}) where {T<:Real,V,D<:Metric} = promote_type(T, V)

"""
    CubicVariogram(sill=s, range=r, nugget=n, distance=d)

A cubic variogram with sill `s`, range `r` and nugget `n`.
Optionally, use a custom distance `d`.
"""
@with_kw struct CubicVariogram{T<:Real,V,D<:Metric} <: AbstractVariogram
  range::T    = one(Float64)
  sill::V     = one(Float64)
  nugget::V   = zero(Float64)
  distance::D = Euclidean()
end
(γ::CubicVariogram)(h) = begin
  s = γ.sill
  r = γ.range
  n = γ.nugget

  (h .< r) .* (s - n) .* (7*(h/r).^2 - (35/4)*(h/r).^3 + (7/2)*(h/r).^5 - (3/4)*(h/r).^7) +
  (h .≥ r) .* (s - n) + n
end
(γ::CubicVariogram)(x, y) = γ(evaluate(γ.distance, x, y))
isstationary(::CubicVariogram) = true
result_type(::CubicVariogram{T,V,D}) where {T<:Real,V,D<:Metric} = promote_type(T, V)

"""
    PentasphericalVariogram

A pentaspherical variogram with sill `s`, range `r` and nugget `n`.
Optionally, use a custom distance `d`.
"""
@with_kw struct PentasphericalVariogram{T<:Real,V,D<:Metric} <: AbstractVariogram
  range::T    = one(Float64)
  sill::V     = one(Float64)
  nugget::V   = zero(Float64)
  distance::D = Euclidean()
end
(γ::PentasphericalVariogram)(h) = begin
  s = γ.sill
  r = γ.range
  n = γ.nugget

  (h .< r) .* (s - n) .* ((15/8)*(h/r) - (5/4)*(h/r).^3 + (3/8)*(h/r).^5) +
  (h .≥ r) .* (s - n) + n
end
(γ::PentasphericalVariogram)(x, y) = γ(evaluate(γ.distance, x, y))
isstationary(::PentasphericalVariogram) = true
result_type(::PentasphericalVariogram{T,V,D}) where {T<:Real,V,D<:Metric} = promote_type(T, V)

"""
    PowerVariogram(scaling=s, exponent=a, nugget=n, distance=d)

A power variogram with scaling `s`, exponent `a` and nugget `n`.
Optionally, use a custom distance `d`.
"""
@with_kw struct PowerVariogram{T<:Real,V,D<:Metric} <: AbstractVariogram
  scaling::T  = one(Float64)
  nugget::V   = zero(Float64)
  exponent    = one(Float64)
  distance::D = Euclidean()
end
(γ::PowerVariogram)(h) = γ.scaling*h.^γ.exponent + γ.nugget
(γ::PowerVariogram)(x, y) = γ(evaluate(γ.distance, x, y))
result_type(::PowerVariogram{T,V,D}) where {T<:Real,V,D<:Metric} = promote_type(T, V)

"""
    SineHoleVariogram(sill=s, range=r, nugget=n, distance=d)

A sine hole variogram with sill `s`, range `r` and nugget `n`.
Optionally, use a custom distance `d`.
"""
@with_kw struct SineHoleVariogram{T<:Real,V,D<:Metric} <: AbstractVariogram
  range::T    = one(Float64)
  sill::V     = one(Float64)
  nugget::V   = zero(Float64)
  distance::D = Euclidean()
end
(γ::SineHoleVariogram)(h) = begin
  s = γ.sill
  r = γ.range
  n = γ.nugget

  # shift lag by machine precision to
  # avoid explosion at the origin
  h = h + eps(eltype(h))

  (s - n) * (1 - sin.(π*h/r)./(π*h/r)) + n
end
(γ::SineHoleVariogram)(x, y) = γ(evaluate(γ.distance, x, y))
isstationary(::SineHoleVariogram) = true
result_type(::SineHoleVariogram{T,V,D}) where {T<:Real,V,D<:Metric} = promote_type(T, V)

"""
    CompositeVariogram(γ₁, γ₂, ..., γₙ)

A composite (additive) model of variograms γ(h) = γ₁(h) + γ₂(h) + ⋯ + γₙ(h).
"""
struct CompositeVariogram <: AbstractVariogram
  γs::Vector{AbstractVariogram}
  CompositeVariogram(g, gs...) = new([g, gs...])
end
(c::CompositeVariogram)(h) = sum(γ(h) for γ in c.γs)
(c::CompositeVariogram)(x, y) = sum(γ(x,y) for γ in c.γs)
result_type(c::CompositeVariogram) = promote_type([result_type(γ) for γ in c.γs]...)
