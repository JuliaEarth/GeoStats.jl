# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

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
  abscissa::Vector{Float64}
  ordinate::Vector{Float64}
  counts::Vector{Int}

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

    # result type of distance between coordinates
    R = result_type(distance, view(X,:,1), view(X,:,1))

    # compute pairwise distance
    lags = Vector{R}(npairs)
    zdiff = Vector{V}(npairs)
    idx = 1
    for j=1:npoints
      xj = view(X,:,j)
      for i=j+1:npoints
        xi = view(X,:,i)
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

    # variogram abscissa, ordinate, and count
    abscissa = linspace(binsize/2, maxlag - binsize/2, nbins)
    ordinate = [length(bin) > 0 ? mean(bin)/2 : NaN for bin in bins]
    counts   = length.(bins)

    new(abscissa, ordinate, counts)
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
    values(γemp)

Returns the center of the bins, the mean squared differences divided by 2
and the number of squared differences at the bins for a given empirical
variogram `γemp`.

## Examples

Plotting empirical variogram manually:

```julia
julia> x, y, n = values(γemp)
julia> plot(x, y, label="variogram")
julia> bar!(x, n, label="histogram")
```
"""
Base.values(γ::EmpiricalVariogram) = γ.abscissa, γ.ordinate, γ.counts
