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
    EmpiricalVariogram(X, z₁, z₂=z₁; [optional parameters])

Computes the empirical (a.k.a. experimental) omnidirectional
(cross-)variogram from data locations `X` and values `z₁` and `z₂`.

    EmpiricalVariogram(spatialdata, var₁, var₂=var₁; [optional parameters])

Alternatively, compute the (cross-)variogram for the variables
`var₁` and `var₂` stored in a `spatialdata` object.

## Parameters

  * nbins - number of bins (default to 20)
  * maxlag - maximum lag distance (default to maximum lag of data)
  * distance - custom distance function
"""
struct EmpiricalVariogram{T<:Real,V,D<:Metric}
  # input fields
  X::AbstractMatrix{T}
  z₁::AbstractVector{V}
  z₂::AbstractVector{V}
  nbins::Int
  maxlag::Union{T,Void}
  distance::D

  # state fields
  bins::Vector{Vector{V}}

  function EmpiricalVariogram{T,V,D}(X, z₁, z₂,
                                     nbins, maxlag,
                                     distance) where {T<:Real,V,D<:Metric}
    # sanity checks
    @assert nbins > 0 "number of bins must be positive"
    if maxlag ≠ nothing
      @assert maxlag > 0 "maximum lag distance must be positive"
    end

    # number of point pairs
    npoints = size(X, 2)
    npairs = (npoints * (npoints-1)) ÷ 2

    # compute pairwise distance
    lags = Vector{T}(npairs)
    zdiff = Vector{V}(npairs)
    idx = 1
    for j=1:npoints
      xj = view(X, :, j)
      for i=j+1:npoints
        xi = view(X, :, i)
        @inbounds lags[idx] = evaluate(distance, xi, xj)
        @inbounds zdiff[idx] = (z₁[i] - z₁[j])*(z₂[i] - z₂[j])
        idx += 1
      end
    end

    # default maximum lag
    maxlag == nothing && (maxlag = maximum(lags))

    # find bin for the pair
    binsize = maxlag / nbins
    binidx = ceil.(Int, lags / binsize)

    # discard lags greater than maximum lag
    zdiff = zdiff[binidx .≤ nbins]
    binidx = binidx[binidx .≤ nbins]

    # place squared differences at the bins
    bins = [zdiff[binidx .== i] for i=1:nbins]

    new(X, z₁, z₂, nbins, maxlag, distance, bins)
  end
end

EmpiricalVariogram(X, z₁, z₂=z₁; nbins=20, maxlag=nothing, distance=Euclidean()) =
  EmpiricalVariogram{eltype(X),eltype(z₁),typeof(distance)}(X, z₁, z₂, nbins, maxlag, distance)

function EmpiricalVariogram(spatialdata::S, var₁::Symbol, var₂::Symbol=var₁;
                            kwargs...) where {S<:AbstractSpatialData}
  npts = npoints(spatialdata)

  X = hcat([coordinates(spatialdata, i) for i in 1:npts]...)
  z₁ = [value(spatialdata, i, var₁) for i in 1:npts]
  z₂ = var₁ ≠ var₂ ? [value(spatialdata, i, var₂) for i in 1:npts] : z₁

  EmpiricalVariogram(X, z₁, z₂; kwargs...)
end

"""
    values(empirical_variogram)

Returns the center of the bins, the mean squared differences divided by 2
and the number of squared differences at the bins.

## Examples

Plotting empirical variogram manually:

```julia
julia> x, y, n = values(empirical_variogram)
julia> plot(x, y, label="semi-variogram")
julia> bar!(x, n, label="histogram")
```
"""
function Base.values(γ::EmpiricalVariogram{T,V,D}) where {T<:Real,V,D<:Metric}
  bins = γ.bins
  nbins = γ.nbins
  binsize = γ.maxlag / γ.nbins

  x = linspace(zero(T) + binsize/2, γ.maxlag - binsize/2, nbins)
  y = [length(bin) > 0 ? mean(bin)/2 : V(NaN) for bin in bins]
  n = length.(bins)

  x, y, n
end
