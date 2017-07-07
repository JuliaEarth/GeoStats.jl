# Empirical variograms

An empirical variogram has the form:

```math
\newcommand{\x}{\boldsymbol{x}}
\hat{\gamma}(h) = \frac{1}{2|N(h)|} \sum_{(i,j) \in N(h)} (z_i - z_j)^2
```

where ``N(h) = \left\{(i,j) \mid ||\x_i - \x_j|| = h\right\}`` is the set
of pairs of locations at a distance ``h`` and ``|N(h)|`` is the cardinality
of the set.

This package currently implements a simple ominidirectional variogram. Other
more flexible types are planned for future releases.

Empirical variograms can be estimated using general distance functions,
please see [Distance functions](distances.md).

## Omnidirectional

```@docs
EmpiricalVariogram
```
