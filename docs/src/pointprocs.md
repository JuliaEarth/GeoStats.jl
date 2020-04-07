# Processes

Point processes can be simulated with the function `rand` on
different [spatial regions](regions.md):

```@docs
rand(::PointProcess, ::AbstractRegion, ::Int)
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
