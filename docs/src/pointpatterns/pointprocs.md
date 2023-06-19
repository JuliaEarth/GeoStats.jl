# Processes

Point processes can be simulated with the function `rand` on
different geometries and domains:

```@docs
Base.rand(::AbstractRNG, ::PointProcess, ::Any, ::Int)
```

For example, a Poisson process with given intensity in a rectangular region:

```@example pointpatterns
using GeoStats # hide
using Plots # hide
using GeoStatsPlots # hide
gr(format=:svg) # hide

p = PoissonProcess(0.1)
b = Box((0.,0.), (100.,100.))

s = rand(p, b, 2)

plot(plot(s[1]), plot(s[2]))
```

or the superposition of two Binomial processes:

```@example pointpatterns
p₁ = BinomialProcess(50)
p₂ = BinomialProcess(50)
p  = p₁ ∪ p₂ # 100 points

s = rand(p, b, 2)

plot(plot(s[1]), plot(s[2]))
```

The homogeneity property of a point process can be checked
with the `ishomogeneous` function:

```@docs
ishomogeneous
```

Below is the list of currently implemented point processes.

## BinomialProcess

```@docs
BinomialProcess
```

## PoissonProcess

```@docs
PoissonProcess
```

## UnionProcess

```@docs
UnionProcess
```
