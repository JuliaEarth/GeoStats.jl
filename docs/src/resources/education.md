# Education

We recommend the following educational resources.

## Learning resources

### Textbooks

- *Isaaks, E. and Srivastava, R. 1990.* [An Introduction to Applied Geostatistics]
  (https://www.amazon.com.br/Introduction-Applied-Geostatistics-Edward-Isaaks/dp/0195050134) -
  An introductory book on geostatistics that covers important concepts with very
  simple language.

- *Chilès, JP and Delfiner, P. 2012.* [Geostatistics: Modeling Spatial Uncertainty]
  (https://onlinelibrary.wiley.com/doi/book/10.1002/9781118136188) - An incredible
  book for those with good mathematical background.

- *Webster, R and Oliver, MA. 2007.* [Geostatistics for Environmental Scientists]
  (https://onlinelibrary.wiley.com/doi/book/10.1002/9780470517277) - A great book
  with good balance between theory and practice.

- *Journel, A. and Huijbregts, Ch. 2003.* [Mining Geostatistics]
  (https://www.amazon.com/Mining-Geostatistics-G-Journel/dp/1930665911) - A great
  book with both theoretical and practical developments.

### Video lectures

- [Júlio Hoffimann](https://www.youtube.com/playlist?list=PLsH4hc788Z1f1e61DN3EV9AhDlpbhhanw) -
  Video lectures with the GeoStats.jl framework.

- [Edward Isaaks](https://www.youtube.com/user/sadeddy/videos) -
  Video lectures on variography, Kriging and related concepts.

- [Jef Caers](https://www.youtube.com/playlist?list=PLh35GyCXlQaQ1LNGWr4vCD9AGOGni8yxq) -
  Video lectures on two-point and multiple-point methods.

### Workshop material

- [UFMG 2023](https://github.com/Arpeggeo/UFMG2023)
  [Portuguese] - Geociência de Dados na Mineração, UFMG 2023

- [JuliaEO 2023](https://github.com/Arpeggeo/JuliaEO2023)
  [English] - Global Workshop on Earth Observation, AIRCentre 2023

- [CBMina 2021](https://github.com/Arpeggeo/CBMina2021)
  [Portuguese] - Introução à Geoestatística, CBMina 2021

- [UFMG 2021](https://github.com/fnaghetini/intro-to-geostats)
  [Portuguese] - Introdução à Geoestatística, UFMG 2021

## Related concepts

### GaussianProcesses.jl

[GaussianProcesses.jl](https://github.com/STOR-i/GaussianProcesses.jl) -
Gaussian process regression and Simple Kriging are essentially
[two names for the same concept](https://en.wikipedia.org/wiki/Kriging).
The derivation of Kriging estimators, however; does **not** require
distributional assumptions. It is a beautiful coincidence that for
multivariate Gaussian distributions, Simple Kriging gives the conditional
expectation.

### KernelFunctions.jl

[KernelFunctions.jl](https://github.com/JuliaGaussianProcesses/KernelFunctions.jl) -
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
Traditional statistical learning relies on core assumptions that do
**not** hold in geospatial settings (fixed support, i.i.d. samples, ...).
[Geostatistical learning](https://www.frontiersin.org/articles/10.3389/fams.2021.689393/full)
has been introduced recently as an attempt to push the frontiers of
statistical learning with geospatial data.
