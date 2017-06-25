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
    GaussianVariogram(s, r, n)

*INPUTS*:

  * s ∈ ℜ - sill
  * r ∈ ℜ - range
  * n ∈ ℜ - nugget
"""
immutable GaussianVariogram{T<:Real} <: AbstractVariogram
  sill::T
  range::T
  nugget::T
end
GaussianVariogram{T<:Real}(s::T, r::T) = GaussianVariogram(s, r, zero(T))
GaussianVariogram() = GaussianVariogram(1.,1.)
(γ::GaussianVariogram)(h) = (γ.sill - γ.nugget) * (1 - exp.(-(h/γ.range).^2)) + γ.nugget

"""
    SphericalVariogram(s, r, n)

*INPUTS*:

  * s ∈ ℜ - sill
  * r ∈ ℜ - range
  * n ∈ ℜ - nugget
"""
immutable SphericalVariogram{T<:Real} <: AbstractVariogram
  sill::T
  range::T
  nugget::T
end
SphericalVariogram{T<:Real}(s::T, r::T) = SphericalVariogram(s, r, zero(T))
SphericalVariogram() = SphericalVariogram(1.,1.)
(γ::SphericalVariogram)(h) = (h .< γ.range) .* (γ.sill - γ.nugget) .* (1 - 1.5h/γ.range + 0.5(h/γ.range).^3) +
                             (h .≥ γ.range) .* (γ.sill - γ.nugget) +
                             γ.nugget

"""
    ExponentialVariogram(s, r, n)

*INPUTS*:

  * s ∈ ℜ - sill
  * r ∈ ℜ - range
  * n ∈ ℜ - nugget
"""
immutable ExponentialVariogram{T<:Real} <: AbstractVariogram
  sill::T
  range::T
  nugget::T
end
ExponentialVariogram{T<:Real}(s::T, r::T) = ExponentialVariogram(s, r, zero(T))
ExponentialVariogram() = ExponentialVariogram(1.,1.)
(γ::ExponentialVariogram)(h) = (γ.sill - γ.nugget) * (1 - exp.(-(h/γ.range))) + γ.nugget

"""
    MaternVariogram(s, r, n, ν)

*INPUTS*:

  * s ∈ ℜ - sill
  * r ∈ ℜ - range
  * n ∈ ℜ - nugget
  * ν ∈ ℜ - order of Bessel function
"""
immutable MaternVariogram{T<:Real} <: AbstractVariogram
  sill::T
  range::T
  nugget::T
  order::T
end
MaternVariogram{T<:Real}(s::T, r::T, n::T) = MaternVariogram(s, r, n, one(T))
MaternVariogram{T<:Real}(s::T, r::T) = MaternVariogram(s, r, zero(T))
MaternVariogram() = MaternVariogram(1.,1.)
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
