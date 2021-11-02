# Education

Geostatistics is often misunderstood as *"classical statistics applied to
geospatial data"*. To correct this unfortunate misunderstanding, the best we
can do as a community is to list educational resources.

## Learning resources

### Books

- *Isaaks, E. and Srivastava, R. 1990.* [An Introduction to Applied Geostatistics]
  (https://www.amazon.com.br/Introduction-Applied-Geostatistics-Edward-Isaaks/dp/0195050134) -
  An introductory book on geostatistics that covers important concepts with very
  simple language.

- *Chilès, JP and Delfiner, P. 2012.* [Geostatistics: Modeling Spatial Uncertainty]
  (https://onlinelibrary.wiley.com/doi/book/10.1002/9781118136188) - An incredible
  book for those with good mathematical background.

- *Journel, A. and Huijbregts, Ch. 2003.* [Mining Geostatistics]
  (https://www.amazon.com/Mining-Geostatistics-G-Journel/dp/1930665911) - A great
  book with both theoretical and practical developments.

### Lectures

- [Júlio Hoffimann](https://www.youtube.com/playlist?list=PLsH4hc788Z1f1e61DN3EV9AhDlpbhhanw) -
  Tutorials on geostatistics with the GeoStats.jl project.

- [Edward Isaaks](https://www.youtube.com/user/sadeddy/videos) -
  Video lectures on variography, Kriging and related concepts.

- [Jef Caers](https://www.youtube.com/playlist?list=PLh35GyCXlQaQ1LNGWr4vCD9AGOGni8yxq) -
  Video lectures on two-point and multiple-point methods.

## Related concepts

### GaussianProcesses.jl

[GaussianProcesses.jl](https://github.com/STOR-i/GaussianProcesses.jl) -
Gaussian process regression and Simple Kriging are essentially
[two names for the same concept](https://en.wikipedia.org/wiki/Kriging).
The derivation of Kriging estimators, however; does **not** require
distributional assumptions. It is a beautiful coincidence that for
multivariate Gaussian distributions, Simple Kriging gives the conditional
expectation. [Matheron](https://en.wikipedia.org/wiki/Georges_Matheron)
and other important geostatisticians have generalized Gaussian processes
to more general random fields with locally-varying mean and for situations
where the mean is unknown. GeoStats.jl includes Gaussian processes as
a special case as well as other more practical Kriging variants.

### MLKernels.jl

[MLKernels.jl](https://github.com/trthatcher/MLKernels.jl) -
Spatial structure can be represented in many different forms: covariance,
variogram, correlogram, etc. Variograms are more general than covariance
kernels according to the intrinsic stationary property. This means that
there are variogram models with no covariance counterpart. Furthermore,
empirical variograms can be easily estimated from the data (in various
directions) with an efficient procedure. GeoStats.jl treats variograms
as first-class objects.

### Interpolations.jl

[Interpolations.jl](https://github.com/JuliaMath/Interpolations.jl) -
Kriging and spline interpolation have different purposes, yet these two
methods are sometimes listed as competing alternatives. Kriging estimation
is about minimizing variance (or estimation error), whereas spline
interpolation is about deriving smooth estimators for *computer visualization*.
[Kriging is a generalization of splines](https://www.sciencedirect.com/science/article/pii/009830048490030X)
in which one has the freedom to customize spatial structure based
on data. Besides the estimate itself, Kriging also provides the
variance map as a function of point patterns.

### MLJ.jl

[MLJ.jl](https://github.com/alan-turing-institute/MLJ.jl) -
Classical statistical learning theory relies on a set of assumptions that do
**not** hold in geospatial settings. Geostatistical learning theory has been
developed for applications where statistical models need to be learned from
geospatial data.
