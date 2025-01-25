# Kriging

!!! note

    This section describes the Kriging models used in the [`Interpolate`](@ref) and
    [`InterpolateNeighbors`](@ref) transforms, which provide options for neighborhood
    search, change of support, etc.

A Kriging model has the form:

```math
\hat{Z}(\p_0) = \lambda_1 Z(\p_1) + \lambda_2 Z(\p_2) + \cdots + \lambda_n Z(\p_n),\quad \p_i \in \R^m, \lambda_i \in \R
```

with ``Z\colon \R^m \times \Omega \to \R`` a random field.

This package implements the following Kriging variants:

- Simple Kriging
- Ordinary Kriging
- Universal Kriging

which can be materialized in code with the generic [`Kriging`](@ref) constructor:

```@docs
Kriging
```

All these variants follow the same interface: an object is first created with a given set
of parameters, it is then combined with the data to obtain predictions at new geometries.

The `fit` function takes care of building the Kriging system and factorizing the LHS with
an appropriate decomposition (e.g. Bunch-Kaufman, LU), and the `predict` (or `predictprob`)
function performs the estimation for a given set of variables and geometry.

```@docs
GeoStatsModels.fit
GeoStatsModels.predict
GeoStatsModels.predictprob
```

All variants work with general Hilbert spaces, meaning that one can interpolate any
data type that implements scalar multiplication, vector addition and inner product.

## Simple Kriging

In Simple Kriging, the mean ``\mu`` of the random field is assumed to be constant *and known*.
The resulting linear system is:

```math
\begin{bmatrix}
cov(\p_1,\p_1) & cov(\p_1,\p_2) & \cdots & cov(\p_1,\p_n) \\
cov(\p_2,\p_1) & cov(\p_2,\p_2) & \cdots & cov(\p_2,\p_n) \\
\vdots & \vdots & \ddots & \vdots \\
cov(\p_n,\p_1) & cov(\p_n,\p_2) & \cdots & cov(\p_n,\p_n)
\end{bmatrix}
\begin{bmatrix}
\lambda_1 \\
\lambda_2 \\
\vdots \\
\lambda_n
\end{bmatrix}
=
\begin{bmatrix}
cov(\p_1,\p_0) \\
cov(\p_2,\p_0) \\
\vdots \\
cov(\p_n,\p_0)
\end{bmatrix}
```
or in matricial form ``\C\l = \c``. We subtract the given mean from the observations
``\boldsymbol{y} = \z - \mu \1`` and compute the mean and variance at location ``\p_0``:

```math
\mu(\p_0) = \mu + \boldsymbol{y}^\top \l
```
```math
\sigma^2(\p_0) = cov(0) - \c^\top \l
```

```@docs
GeoStatsModels.SimpleKriging
```

## Ordinary Kriging

In Ordinary Kriging the mean of the random field is assumed to be constant *and unknown*.
The resulting linear system is:

```math
\begin{bmatrix}
\G & \1 \\
\1^\top & 0
\end{bmatrix}
\begin{bmatrix}
\l \\
\nu
\end{bmatrix}
=
\begin{bmatrix}
\g \\
1
\end{bmatrix}
```
with ``\nu`` the Lagrange multiplier associated with the constraint ``\1^\top \l = 1``. The mean and variance at
location ``\p_0`` are given by:

```math
\mu(\p_0) = \z^\top \l
```
```math
\sigma^2(\p_0) =  \begin{bmatrix} \g \\ 1 \end{bmatrix}^\top \begin{bmatrix} \l \\ \nu \end{bmatrix}
```

```@docs
GeoStatsModels.OrdinaryKriging
```

## Universal Kriging

In Universal Kriging, the mean of the random field is assumed to be a linear combination of known smooth functions.
For example, it is common to assume

```math
\mu(\p) = \sum_{k=1}^{N_d} \beta_k f_k(\p)
```
with ``N_d`` monomials ``f_k`` of degree up to ``d``. For example, in 2D there are ``6`` monomials of degree up to ``2``:

```math
\mu(x_1,x_2) =  \beta_1 1 + \beta_2 x_1 + \beta_3 x_2 + \beta_4 x_1 x_2 + \beta_5 x_1^2 + \beta_6 x_2^2
```

The choice of the degree ``d`` determines the size of the polynomial matrix

```math
\F =
\begin{bmatrix}
f_1(\p_1) & f_2(\p_1) & \cdots & f_{N_d}(\p_1) \\
f_1(\p_2) & f_2(\p_2) & \cdots & f_{N_d}(\p_2) \\
\vdots & \vdots & \ddots & \vdots \\
f_1(\p_n) & f_2(\p_n) & \cdots & f_{N_d}(\p_n)
\end{bmatrix}
```

and polynomial vector ``\f = \begin{bmatrix} f_1(\p_0) & f_2(\p_0) & \cdots & f_{N_d}(\p_0) \end{bmatrix}^\top``.

The variogram determines the variogram matrix:

```math
\G =
\begin{bmatrix}
\gamma(\p_1,\p_1) & \gamma(\p_1,\p_2) & \cdots & \gamma(\p_1,\p_n) \\
\gamma(\p_2,\p_1) & \gamma(\p_2,\p_2) & \cdots & \gamma(\p_2,\p_n) \\
\vdots & \vdots & \ddots & \vdots \\
\gamma(\p_n,\p_1) & \gamma(\p_n,\p_2) & \cdots & \gamma(\p_n,\p_n)
\end{bmatrix}
```
and the variogram vector
``\g = \begin{bmatrix} \gamma(\p_1,\p_0) & \gamma(\p_2,\p_0) & \cdots & \gamma(\p_n,\p_0) \end{bmatrix}^\top``.

The resulting linear system is:

```math
\begin{bmatrix}
\G & \F \\
\F^\top & \boldsymbol{0}
\end{bmatrix}
\begin{bmatrix}
\l \\
\boldsymbol{\nu}
\end{bmatrix}
=
\begin{bmatrix}
\g \\
\f
\end{bmatrix}
```
with ``\boldsymbol{\nu}`` the Lagrange multipliers associated with the universal constraints. The mean and
variance at location ``\p_0`` are given by:

```math
\mu(\p_0) = \z^\top \l
```
```math
\sigma^2(\p_0) = \begin{bmatrix}\g \\ \f\end{bmatrix}^\top \begin{bmatrix}\l \\ \boldsymbol{\nu}\end{bmatrix}
```

```@docs
GeoStatsModels.UniversalKriging
```
