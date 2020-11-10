# Education

Geostatistics is often misunderstood as "classical statistics applied to
spatial data". To correct this unfortunate misunderstanding, the best we
can do as a community is to list additional learning resources for newcomers.
Below is one such a list including related projects with clarifying comments,
links to papers, books and video lectures.

## Related projects

### GaussianProcesses.jl

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
[Gaussian processes example](https://github.com/JuliaEarth/GeoStatsTutorials).

### MLKernels.jl

[MLKernels.jl](https://github.com/trthatcher/MLKernels.jl) -
Spatial structure can be represented in many different forms: covariance,
variogram, correlogram, etc. Variograms are more general than covariance
kernels according to the intrinsic stationary property. This means that
there are variogram models with no covariance counterpart. Furthermore,
empirical variograms can be easily estimated from the data (in various
directions) with an efficient procedure. GeoStats.jl treats variograms
as first-class objects, see the
[Variogram modeling example](https://github.com/JuliaEarth/GeoStatsTutorials).

### Interpolations.jl

[Interpolations.jl](https://github.com/JuliaMath/Interpolations.jl) -
Kriging and Spline interpolation have different purposes, yet these two
methods are sometimes listed as competing alternatives. Kriging estimation
is about minimizing variance (or estimation error), whereas Spline
interpolation is about forcedly smooth estimators derived for
*computer visualization*.
[Kriging is a generalization of Splines](https://www.sciencedirect.com/science/article/pii/009830048490030X)
in which one has the freedom to customize spatial structure based
on data. Besides the estimate itself, Kriging also provides the
variance map as a function of knots configuration.

### MLJ.jl

[MLJ.jl](https://github.com/alan-turing-institute/MLJ.jl) -
Statistical learning theory relies on a set of assumptions that do
**not** hold with spatial data (e.g i.i.d. samples on fixed-size support,
stationarity, to name a few). Geostatistical learning theory generalizes
traditional machine learning for applications where statistical models
need to be learned from spatial data.

## Learning resources

### Books

- *Isaaks, E. and Srivastava, R. 1990.* [An Introduction to Applied Geostatistics]
  (https://www.amazon.com.br/Introduction-Applied-Geostatistics-Edward-Isaaks/dp/0195050134) -
  An introductory book on geostatistics that covers important concepts with very
  simple language.

- *Chilès, JP and Delfiner, P. 2012.* [Geostatistics: Modeling Spatial Uncertainty]
  (https://onlinelibrary.wiley.com/doi/book/10.1002/9781118136188) - An incredible
  book for those with good mathematical background.

### Lectures

- [Júlio Hoffimann](https://www.youtube.com/playlist?list=PLsH4hc788Z1f1e61DN3EV9AhDlpbhhanw) -
  Tutorials on geostatistics with the GeoStats.jl project.

- [Edward Isaaks](https://www.youtube.com/user/sadeddy/videos) -
  Video lectures on variography, Kriging and related concepts.

- [Jef Caers](https://www.youtube.com/playlist?list=PLh35GyCXlQaQ1LNGWr4vCD9AGOGni8yxq) -
  Video lectures on two-point and multiple-point methods.

## Related publications

Below is a list of publications made possible with this project:

- *Hoffimann, J. & Zadrozny, B. 2019.* [Efficient Variography with Partition Variograms]
  (https://www.sciencedirect.com/science/article/pii/S0098300419302936)

- *Hoffimann et al. 2019.* [Morphodynamic Analysis and Statistical Synthesis of Geomorphic Data:
  Application to a Flume Experiment](https://agupubs.onlinelibrary.wiley.com/doi/abs/10.1029/2019JF005245)

- *Barfod et al. 2017.* [Hydrostratigraphic Modeling using Multiple-point Statistics and Airbone Transient
  Electromagnetic Methods](https://hess.copernicus.org/articles/22/3351/2018)

- *Hoffimann et al. 2017.* [Stochastic Simulation by Image Quilting of Process-based Geological Models]
  (https://www.sciencedirect.com/science/article/pii/S0098300417301139)
