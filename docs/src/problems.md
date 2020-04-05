# Problems

The project provides solutions to three three types of problems defined below.

## Estimation

An estimation problem in geostatitsics is a triplet:

1. Spatial data (i.e. data with coordinates)
2. Spatial domain (e.g. regular grid, point collection)
3. Target variables (or variables to be estimated)

Each of these components is constructed separately, and then grouped
(no memory is copied) in an `EstimationProblem`.

```@docs
EstimationProblem
```

## Simulation

Likewise, a stochastic simulation problem in geostatistics is represented with
the same triplet. However, the spatial data in this case is optional in order
to accomodate the concept of conditional versus unconditional simulation.

```@docs
SimulationProblem
```

## Learning

A geostatistical learning problem consists of a triplet:

1. Source spatial data (e.g. with labels)
2. Target spatial data (e.g. without labels)
3. Learning task (e.g. classification)

In this case, a learning model is trained with the source spatial data, and then
used to perform the same task with the target spatial data.

```@docs
LearningProblem
```
