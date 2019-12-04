# Related packages

## GaussianProcesses.jl

[GaussianProcesses.jl](https://github.com/STOR-i/GaussianProcesses.jl) -
Gaussian processes (the method) and Simple Kriging are essentially
[two names for the same concept](https://en.wikipedia.org/wiki/Kriging).
The derivation of Kriging estimators, however; does **not** require
distributional assumptions. It is a beautiful coincidence that for
multivariate Gaussian distributions, Simple Kriging gives the conditional
expectation. [Matheron](https://en.wikipedia.org/wiki/Georges_Matheron)
and other important geostatisticians have generalized Gaussian processes
to more general random fields with locally-varying mean and for situations
where the mean is unknown. GeoStats.jl includes Gaussian processes as
a special case as well as other more practical Kriging variants, see the
[Gaussian processes example](https://github.com/juliohm/GeoStatsTutorials).

## MLKernels.jl

[MLKernels.jl](https://github.com/trthatcher/MLKernels.jl) -
Spatial structure can be represented in many different forms: covariance,
variogram, correlogram, etc. Variograms are more general than covariance
kernels according to the intrinsic stationary property. This means that
there are variogram models with no covariance counterpart. Furthermore,
empirical variograms can be easily estimated from the data (in various
directions) with an efficient procedure. GeoStats.jl treats variograms
as first-class objects, see the
[Variogram modeling example](https://github.com/juliohm/GeoStatsTutorials).

## Interpolations.jl

[Interpolations.jl](https://github.com/JuliaMath/Interpolations.jl) -
Kriging and Spline interpolation have different purposes, yet these two
methods are sometimes listed as competing alternatives. Kriging estimation
is about minimizing variance (or estimation error), whereas Spline
interpolation is about forcedly smooth estimators derived for
*computer visualization*.
[Kriging is a generalization of Splines](http://www.sciencedirect.com/science/article/pii/009830048490030X)
in which one has the freedom to customize spatial structure based
on data. Besides the estimate itself, Kriging also provides the
variance map as a function of knots configuration.

## MLJ.jl

[MLJ.jl](https://github.com/alan-turing-institute/MLJ.jl) -
Statistical learning (a.k.a. machine learning) theory relies on a set of
assumptions that do **not** hold with spatial data (e.g i.i.d. samples on
fixed-size support, stationarity, to name a few). Geostatistical learning
theory generalizes traditional machine learning for applications where
statistical models need to be learned from spatial data.
