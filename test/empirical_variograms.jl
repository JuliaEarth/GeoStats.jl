@testset "Empirical variograms" begin
  # homogeneous field has zero variogram
  γ = EmpiricalVariogram(eye(3), ones(3), nbins=2, maxlag=2.)
  x, y, n = GeoStats.values(γ)
  @test x ≈ [1/2, 3/2]
  @test isnan(y[1]) && y[2] == 0.
  @test n == [0, 3]
end
