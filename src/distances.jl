## Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
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
    AbstractDistance

A metric or distance function.
"""
abstract type AbstractDistance end

"""
    EuclideanDistance

The Euclidean distance ||x-y||₂
"""
struct EuclideanDistance <: AbstractDistance end
(d::EuclideanDistance)(x, y) = norm(x - y)

"""
    EllipsoidDistance(semiaxes, angles)

A distance defined by an ellipsoid with given `semiaxes` and rotation `angles`.

- For 2D ellipsoids, there are two semiaxes and one rotation angle.
- For 3D ellipsoids, there are three semiaxes and three rotation angles.

## Examples

2D ellipsoid making 45ᵒ with the horizontal axis:

```julia
julia> EllipsoidDistance([1.0,0.5], [π/2])
```

3D ellipsoid rotated by 45ᵒ in the xy plane:

```julia
julia> EllipsoidDistance([1.0,0.5,0.5], [π/2,0.0,0.0])
```

### Notes

The positive definite matrix representing the ellipsoid is assembled
once during object construction and cached for fast evaluation.
"""
struct EllipsoidDistance{N,T<:Real} <: AbstractDistance
  A::Matrix{T}

  function EllipsoidDistance{N,T}(semiaxes, angles) where {N,T<:Real}
    @assert length(semiaxes) == N "number of semiaxes must match spatial dimension"
    @assert all(semiaxes .> zero(T)) "semiaxes must be positive"

    # scaling matrix
    Λ = spdiagm(one(T)./semiaxes.^2)

    # rotation matrix
    P = []
    if N == 2
      θ = angles[1]
      P = [cos(θ) -sin(θ)
           sin(θ)  cos(θ)]
    elseif N == 3
      @assert length(angles) == 3 "there must be three angles in 3D"
      θxy, θyz, θzx = angles
      Rxy = [cos(θxy) -sin(θxy) zero(T)
             sin(θxy)  cos(θxy) zero(T)
              zero(T)   zero(T)  one(T)]
      Ryz = [ one(T)  zero(T)   zero(T)
             zero(T) cos(θyz) -sin(θyz)
             zero(T) sin(θyz)  cos(θyz)]
      Rzx = [cos(θzx) zero(T) sin(θzx)
              zero(T)  one(T)  zero(T)
            -sin(θzx) zero(T) cos(θzx)]
      P = Rzx*Ryz*Rxy
    else
      error("ellipsoid distance not implemented for dimension > 3D")
    end

    # ellipsoid matrix
    A = P*Λ*P'

    new(A)
  end
end
EllipsoidDistance(semiaxes::Vector{T}, angles::Vector{T}) where {T<:Real} =
  EllipsoidDistance{length(semiaxes),T}(semiaxes, angles)
(d::EllipsoidDistance)(x, y) = (z = x-y; √(z'*d.A*z))

"""
    HaversineDistance(radius)

The haversine distance between two locations on a sphere of given `radius`.

Locations are described with latitude and longitude in degrees and
the radius of the Earth is used by default (≈ 6371km). The computed
distance has the same units as that of the radius.

### Notes

The haversine formula is widely used to approximate the geodesic distance
between two points at the surface of the Earth. The error from approximating
the Earth as a sphere is typically negligible for most applications. It is
no more than 0.3%.
"""
struct HaversineDistance{T<:Real} <: AbstractDistance
  radius::T
end
HaversineDistance() = HaversineDistance(6371.) # Earth radius ≈ 6371km
(d::HaversineDistance)(x, y) = begin
  # latitudes
  φ₁ = deg2rad(x[1])
  φ₂ = deg2rad(y[1])
  Δφ = φ₂ - φ₁

  # longitudes
  Δλ = deg2rad(y[2] - x[2])

  # haversine formula
  a = sin(Δφ/2)^2 + cos(φ₁)*cos(φ₂)*sin(Δλ/2)^2
  c = 2atan2(√a, √(1-a))

  # distance on the sphere
  c*d.radius
end
