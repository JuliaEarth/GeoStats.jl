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

abstract CovarianceModel

immutable GaussianCovariance{T<:Real} <: CovarianceModel
  nugget::T
  sill::T
  range::T
end
GaussianCovariance() = GaussianCovariance(0.,1.,1.)
(c::GaussianCovariance)(h) = (c.sill - c.nugget) * exp(-(h/c.range).^2)

immutable SphericalCovariance{T<:Real} <: CovarianceModel
  nugget::T
  sill::T
  range::T
end
SphericalCovariance() = SphericalCovariance(0.,1.,1.)
(c::SphericalCovariance)(h) = (h .≤ c.range) .* (c.sill - c.nugget) .* (1 - 1.5h/c.range + 0.5(h/c.range).^3)

immutable ExponentialCovariance{T<:Real} <: CovarianceModel
  nugget::T
  sill::T
  range::T
end
ExponentialCovariance() = ExponentialCovariance(0.,1.,1.)
(c::ExponentialCovariance)(h) = (c.sill - c.nugget) * exp(-(h/c.range))
