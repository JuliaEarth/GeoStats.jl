@testset "Theoretical variograms" begin
  h = linspace(0,10)
  x, y = rand(3), rand(3)

  # stationary variogram models
  γs = [GaussianVariogram(), SphericalVariogram(),
        ExponentialVariogram(), MaternVariogram(),
        SphericalVariogram(range=2.)]

  # non-stationary variogram models
  γn = [PowerVariogram()]

  # check stationarity
  @test all(isstationary(γ) for γ ∈ γs)

  # check non-stationarity
  @test all(!isstationary(γ) for γ ∈ γn)

  for γ in [γs..., CompositeVariogram(γs...)]
    # variograms are increasing
    @test all(γ(h) .≤ γ(h+1))

    # variograms are symmetric
    @test γ(x, y) ≈ γ(y, x)
  end

  if ismaintainer || istravis
    @testset "Plot recipe" begin
      function plot_variograms(fname)
        plt = plot()
        for γ ∈ γs
          plot!(plt, γ, maxlag=3.)
        end
        png(fname)
      end
      refimg = joinpath(datadir,"TheoreticalVariograms.png")
      @test test_images(VisualTest(plot_variograms, refimg), popup=!istravis) |> success
    end
  end
end
