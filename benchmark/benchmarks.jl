using GeoStats
using PkgBenchmark

srand(2017)

datadir = joinpath(@__DIR__,"data")

fname = joinpath(datadir,"permeability.csv")
geodata = readtable(fname, coordnames=[:x,:y])
domain = bounding_grid(geodata, [100,100])
problem = EstimationProblem(geodata, domain, :permeability)

@benchgroup "Empirical variogram" begin
  @bench "autovariogram" EmpiricalVariogram($geodata, :permeability)
end

@benchgroup "Kriging" begin
  solver₁ = Kriging(:permeability => @NT(variogram=ExponentialVariogram(range=40.)))
  solver₂ = Kriging(:permeability => @NT(variogram=SphericalVariogram(range=40.)))
  solver₃ = Kriging(:permeability => @NT(variogram=GaussianVariogram(range=40.)))

  @bench "Exponential variogram" solve($problem, solver₁)
  @bench "Spherical variogram" solve($problem, solver₂)
  @bench "Gaussian variogram" solve($problem, solver₃)
end
