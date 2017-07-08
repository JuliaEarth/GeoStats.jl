@testset "Theoretical variograms" begin
  h = linspace(0,10)
  x, y = rand(3), rand(3)

  γs = [GaussianVariogram(), SphericalVariogram(),
        ExponentialVariogram(), MaternVariogram(),
        SphericalVariogram(range=2.)]

  for γ in [γs..., CompositeVariogram(γs...)]
    # variograms are increasing
    @test all(γ(h) .≤ γ(h+1))

    # variograms are symmetric
    @test γ(x, y) ≈ γ(y, x)
  end
end
