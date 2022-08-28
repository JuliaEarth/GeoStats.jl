# Ensembles

```@docs
Ensemble
```

Consider the following solution to a conditional simulation problem:

```@example ensemble
using GeoStats
using Plots, GeoStatsPlots
gr(size=(900,400)) # hide

# geospatial samples
S = let
  coord = [(25.,25.), (50.,75.), (75.,50.)]
  table = (z=[1.,0.,1.],)
  georef(table, coord)
end

# simulation domain
D = CartesianGrid(100, 100)

# request 100 realizations
problem = SimulationProblem(S, D, :z, 100)

# LU Gaussian simulation
solver = LUGS(:z => (variogram=GaussianVariogram(range=30.),))

# realizations form an ensemble
ensemble = solve(problem, solver)
```

We can visualize a few realizations in the ensemble:

```@example ensemble
z1 = ensemble[1]
z2 = ensemble[2]
z3 = ensemble[3]
z4 = ensemble[4]

plot(plot(z1), plot(z2),
     plot(z3), plot(z4),
     size=(900,800))
```

or alternatively, the mean and variance:

```@example ensemble
m = mean(ensemble)
v = var(ensemble)

p1 = plot(m, title="mean")
p2 = plot(v, title="variance")

plot(p1, p2)
```

or the 25th and 75th percentiles:

```@example ensemble
a = quantile(ensemble, 0.25)
b = quantile(ensemble, 0.75)

p1 = plot(a, title="25th percentile")
p2 = plot(b, title="75th percentile")

plot(p1, p2)
```

All these objects are examples of geospatial data as described in
the [Data](data.md) section.