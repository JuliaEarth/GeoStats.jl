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

A Gaussian variogram with sill `s`, range `r` and nugget `n`.
"""
@with_kw immutable GaussianVariogram{T<:Real} <: AbstractVariogram
  sill::T   = 1.
  range::T  = 1.
  nugget::T = 0.
end
(γ::GaussianVariogram)(h) = (γ.sill - γ.nugget) * (1 - exp.(-(h/γ.range).^2)) + γ.nugget

"""
    SphericalVariogram(s, r, n)

A spherical variogram with sill `s`, range `r` and nugget `n`.
"""
@with_kw immutable SphericalVariogram{T<:Real} <: AbstractVariogram
  sill::T   = 1.
  range::T  = 1.
  nugget::T = 0.
end
(γ::SphericalVariogram)(h) = (h .< γ.range) .* (γ.sill - γ.nugget) .* (1 - 1.5h/γ.range + 0.5(h/γ.range).^3) +
                             (h .≥ γ.range) .* (γ.sill - γ.nugget) +
                             γ.nugget

"""
    ExponentialVariogram(s, r, n)

An exponential variogram with sill `s`, range `r` and nugget `n`.
"""
@with_kw immutable ExponentialVariogram{T<:Real} <: AbstractVariogram
  sill::T   = 1.
  range::T  = 1.
  nugget::T = 0.
end
(γ::ExponentialVariogram)(h) = (γ.sill - γ.nugget) * (1 - exp.(-(h/γ.range))) + γ.nugget

"""
    MaternVariogram(s, r, n, ν)

A Matérn variogram with sill `s`, range `r` and nugget `n`. The parameter
ν is the order of the Bessel function.
"""
@with_kw immutable MaternVariogram{T<:Real} <: AbstractVariogram
  sill::T   = 1.
  range::T  = 1.
  nugget::T = 0.
  order::T  = 1.
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
