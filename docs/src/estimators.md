# Kriging estimators

A Kriging estimator has the form:

```math
\newcommand{\x}{\boldsymbol{x}}
\newcommand{\R}{\mathbb{R}}
\hat{Z}(\x_0) = \lambda_1 Z(\x_1) + \lambda_2 Z(\x_2) + \cdots + \lambda_n Z(\x_n),\quad \x_i \in \R^m, \lambda_i \in \R
```

with ``Z\colon \R^m \times \Omega \to \R`` a random field.

This package implements the following Kriging variants:

- Simple Kriging
- Ordinary Kriging
- Universal Kriging
- External Drift Kriging

All these variants follow the same interface: an `estimator` object is first created with a
given set of parameters (e.g. `estimator = OrdinaryKriging(γ)`), it is then combined with the
data `krig = fit(estimator, X, z)` to obtain predictions at new locations `predict(krig, xₒ)`.

The `fit` function takes care of building the Kriging system and factorizing the LHS with
an appropriate decomposition (e.g. Cholesky, LU):

```@docs
KrigingEstimators.fit
```

The `predict` function performs the estimation at a given location:

```@docs
predict
```

Alternative constructors are provided for convenience that will immediately fit the Kriging
parameters to the data. In this case, the data is passed as the first argument. For example:

```julia
OrdinaryKriging(X, z, γ)
```

creates a `OrdinaryKriging(γ)` estimator and fits it to `(X,z)`.

A typical use of the interface is as follows:

```julia
# build and factorize the system
sk = SimpleKriging(X, z, γ, mean(z))

# estimate at various locations
for xₒ in [x₁, x₂, x₃]
  μ, σ² = predict(sk, xₒ)
end
```

For advanced users, the Kriging weights and Lagrange multipliers at a given location can be accessed
with the `weights` method. This method returns a `KrigingWeights` object containing a field `λ` for
the weights and a field `ν` for the Lagrange multipliers:

```@docs
weights
```

For example with Ordinary Kriging:

```julia
ok = OrdinaryKriging(X, z, γ)
w = weights(ok, xₒ)
w.λ, w.ν
```

## Simple Kriging

In Simple Kriging, the mean ``\mu`` of the random field is assumed to be constant *and known*.
The resulting linear system is:

```math
\newcommand{\C}{\boldsymbol{C}}
\newcommand{\c}{\boldsymbol{c}}
\newcommand{\l}{\boldsymbol{\lambda}}
\newcommand{\1}{\boldsymbol{1}}
\newcommand{\z}{\boldsymbol{z}}
\begin{bmatrix}
cov(\x_1,\x_1) & cov(\x_1,\x_2) & \cdots & cov(\x_1,\x_n) \\
cov(\x_2,\x_1) & cov(\x_2,\x_2) & \cdots & cov(\x_2,\x_n) \\
\vdots & \vdots & \ddots & \vdots \\
cov(\x_n,\x_1) & cov(\x_n,\x_2) & \cdots & cov(\x_n,\x_n)
\end{bmatrix}
\begin{bmatrix}
\lambda_1 \\
\lambda_2 \\
\vdots \\
\lambda_n
\end{bmatrix}
=
\begin{bmatrix}
cov(\x_1,\x_0) \\
cov(\x_2,\x_0) \\
\vdots \\
cov(\x_n,\x_0)
\end{bmatrix}
```
or in matricial form ``\C\l = \c``. We subtract the given mean from the observations
``\boldsymbol{y} = \z - \mu \1`` and compute the mean and variance at location ``\x_0``:

```math
\mu(\x_0) = \mu + \boldsymbol{y}^\top \l
```
```math
\sigma^2(\x_0) = cov(0) - \c^\top \l
```

```@docs
SimpleKriging
```

## Ordinary Kriging

In Ordinary Kriging the mean of the random field is assumed to be constant *and unknown*. The resulting linear
system is:

```math
\newcommand{\G}{\boldsymbol{\Gamma}}
\newcommand{\g}{\boldsymbol{\gamma}}
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
location ``\x_0`` are given by:

```math
\mu(\x_0) = \z^\top \lambda
```
```math
\sigma^2(\x_0) =  \begin{bmatrix} \g \\ 1 \end{bmatrix}^\top \begin{bmatrix} \l \\ \nu \end{bmatrix}
```

```@docs
OrdinaryKriging
```

## Universal Kriging

In Universal Kriging, the mean of the random field is assumed to be a polynomial of the spatial coordinates:

```math
\mu(\x) = \sum_{k=1}^{N_d} \beta_k f_k(\x)
```
with ``N_d`` monomials ``f_k`` of degree up to ``d``. For example, in 2D there are ``6`` monomials of degree up to ``2``:

```math
\mu(x_1,x_2) =  \beta_1 1 + \beta_2 x_1 + \beta_3 x_2 + \beta_4 x_1 x_2 + \beta_5 x_1^2 + \beta_6 x_2^2
```

The choice of the degree ``d`` determines the size of the polynomial matrix

```math
\newcommand{\F}{\boldsymbol{F}}
\newcommand{\f}{\boldsymbol{f}}
\F =
\begin{bmatrix}
f_1(\x_1) & f_2(\x_1) & \cdots & f_{N_d}(\x_1) \\
f_1(\x_2) & f_2(\x_2) & \cdots & f_{N_d}(\x_2) \\
\vdots & \vdots & \ddots & \vdots \\
f_1(\x_n) & f_2(\x_n) & \cdots & f_{N_d}(\x_n)
\end{bmatrix}
```

and polynomial vector ``\f = \begin{bmatrix} f_1(\x_0) & f_2(\x_0) & \cdots & f_{N_d}(\x_0) \end{bmatrix}^\top``.

The variogram determines the variogram matrix:

```math
\G =
\begin{bmatrix}
\gamma(\x_1,\x_1) & \gamma(\x_1,\x_2) & \cdots & \gamma(\x_1,\x_n) \\
\gamma(\x_2,\x_1) & \gamma(\x_2,\x_2) & \cdots & \gamma(\x_2,\x_n) \\
\vdots & \vdots & \ddots & \vdots \\
\gamma(\x_n,\x_1) & \gamma(\x_n,\x_2) & \cdots & \gamma(\x_n,\x_n)
\end{bmatrix}
```
and the variogram vector
``\g = \begin{bmatrix} \gamma(\x_1,\x_0) & \gamma(\x_2,\x_0) & \cdots & \gamma(\x_n,\x_0) \end{bmatrix}^\top``.

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
variance at location ``\x_0`` are given by:

```math
\mu(\x_0) = \z^\top \l
```
```math
\sigma^2(\x_0) = \begin{bmatrix}\g \\ \f\end{bmatrix}^\top \begin{bmatrix}\l \\ \boldsymbol{\nu}\end{bmatrix}
```

```@docs
UniversalKriging
```

## External Drift Kriging

In External Drift Kriging, the mean of the random field is assumed to be a combination of known smooth functions:

```math
\mu(\x) = \sum_k \beta_k m_k(\x)
```

Differently than Universal Kriging, the functions ``m_k`` are not necessarily polynomials of the spatial coordinates.
In practice, they represent a list of variables that is strongly correlated (and co-located) with the variable being
estimated.

External drifts are known to cause numerical instability. Give preference to other Kriging variants if possible.

```@docs
ExternalDriftKriging
```
