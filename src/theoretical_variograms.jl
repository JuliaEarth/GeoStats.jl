## Copyright (c) 2015, Júlio Hoffimann Mendes <juliohm@stanford.edu>
##
## Permission to use, copy, modify, and/or distribute this software for any
## purpose with or without fee is hereby granted, provided that the above
## copyright notice and this permission notice appear in all copies.
##
## THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
## WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
## ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
## WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
## ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
## OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

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

#------------------
# IMPLEMENTATIONS
#------------------
"""
    GaussianVariogram(sill=s, range=r, nugget=n, distance=d)

A Gaussian variogram with sill `s`, range `r` and nugget `n`.
Optionally, use a custom distance `d`.
"""
@with_kw struct GaussianVariogram{T<:Real,D<:AbstractDistance} <: AbstractVariogram
  sill::T   = 1.
  range::T  = 1.
  nugget::T = 0.
  distance::D = EuclideanDistance()
end
(γ::GaussianVariogram)(h) = (γ.sill - γ.nugget) * (1 - exp.(-(h/γ.range).^2)) + γ.nugget
(γ::GaussianVariogram)(x, y) = γ(γ.distance(x, y))
isstationary(::GaussianVariogram) = true

"""
    SphericalVariogram(sill=s, range=r, nugget=n, distance=d)

A spherical variogram with sill `s`, range `r` and nugget `n`.
Optionally, use a custom distance `d`.
"""
@with_kw struct SphericalVariogram{T<:Real,D<:AbstractDistance} <: AbstractVariogram
  sill::T   = 1.
  range::T  = 1.
  nugget::T = 0.
  distance::D = EuclideanDistance()
end
(γ::SphericalVariogram)(h) = (h .< γ.range) .* (γ.sill - γ.nugget) .* (1.5h/γ.range - 0.5(h/γ.range).^3) +
                             (h .≥ γ.range) .* (γ.sill - γ.nugget) +
                             γ.nugget
(γ::SphericalVariogram)(x, y) = γ(γ.distance(x, y))
isstationary(::SphericalVariogram) = true

"""
    ExponentialVariogram(sill=s, range=r, nugget=n, distance=d)

An exponential variogram with sill `s`, range `r` and nugget `n`.
Optionally, use a custom distance `d`.
"""
@with_kw struct ExponentialVariogram{T<:Real,D<:AbstractDistance} <: AbstractVariogram
  sill::T   = 1.
  range::T  = 1.
  nugget::T = 0.
  distance::D = EuclideanDistance()
end
(γ::ExponentialVariogram)(h) = (γ.sill - γ.nugget) * (1 - exp.(-(h/γ.range))) + γ.nugget
(γ::ExponentialVariogram)(x, y) = γ(γ.distance(x, y))
isstationary(::ExponentialVariogram) = true

"""
    MaternVariogram(sill=s, range=r, nugget=n, order=ν, distance=d)

A Matérn variogram with sill `s`, range `r` and nugget `n`. The parameter
ν is the order of the Bessel function. Optionally, use a custom distance `d`.
"""
@with_kw struct MaternVariogram{T<:Real,D<:AbstractDistance} <: AbstractVariogram
  sill::T   = 1.
  range::T  = 1.
  nugget::T = 0.
  order::T  = 1.
  distance::D = EuclideanDistance()
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

  (s - n) * (1 - 2.0^(1 - ν)/gamma(ν) * h3.^ν .* besselk.(ν, h3))
end
(γ::MaternVariogram)(x, y) = γ(γ.distance(x, y))
isstationary(::MaternVariogram) = true

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
