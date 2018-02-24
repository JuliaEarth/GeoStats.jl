# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    Ellipsoidal(semiaxes, angles)

A distance defined by an ellipsoid with given `semiaxes` and rotation `angles`.

- For 2D ellipsoids, there are two semiaxes and one rotation angle.
- For 3D ellipsoids, there are three semiaxes and three rotation angles.

## Examples

2D ellipsoid making 45ᵒ with the horizontal axis:

```julia
julia> Ellipsoidal([1.0,0.5], [π/2])
```

3D ellipsoid rotated by 45ᵒ in the xy plane:

```julia
julia> Ellipsoidal([1.0,0.5,0.5], [π/2,0.0,0.0])
```
"""
struct Ellipsoidal{N,T} <: Metric
  dist::Mahalanobis{T}

  function Ellipsoidal{N,T}(semiaxes, angles) where {N,T<:Real}
    @assert length(semiaxes) == N "number of semiaxes must match spatial dimension"
    @assert all(semiaxes .> zero(T)) "semiaxes must be positive"
    @assert N ∈ [2,3] "dimension must be either 2 or 3"

    # scaling matrix
    Λ = spdiagm(one(T)./semiaxes.^2)

    # rotation matrix
    if N == 2
      θ = angles[1]

      cosθ = cos(θ)
      sinθ = sin(θ)

      P = [cosθ -sinθ
           sinθ  cosθ]
    end
    if N == 3
      θxy, θyz, θzx = angles

      cosxy = cos(θxy)
      sinxy = sin(θxy)
      cosyz = cos(θyz)
      sinyz = sin(θyz)
      coszx = cos(θzx)
      sinzx = sin(θzx)

      _1 = one(T)
      _0 = zero(T)

      Rxy = [cosxy -sinxy _0
             sinxy  cosxy _0
             _0     _0 _1]

      Ryz = [_1    _0     _0
             _0 cosyz -sinyz
             _0 sinyz  cosyz]

      Rzx = [ coszx _0 sinzx
             _0 _1    _0
             -sinzx _0 coszx]

      P = Rzx*Ryz*Rxy
    end

    # ellipsoid matrix
    Q = P*Λ*P'

    new(Mahalanobis(Q))
  end
end

Ellipsoidal(semiaxes::AbstractVector{T}, angles::AbstractVector{T}) where {T<:Real} =
  Ellipsoidal{length(semiaxes),T}(semiaxes, angles)

function Distances.evaluate(dist::Ellipsoidal{N,T}, a::AbstractVector, b::AbstractVector) where {N,T<:Real}
  evaluate(dist.dist, a, b)
end
