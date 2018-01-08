@testset "Theoretical variograms" begin
  h = linspace(0,10)
  x, y = rand(3), rand(3)

  # stationary variogram models
  γs = [GaussianVariogram(), ExponentialVariogram(),
        MaternVariogram(), SphericalVariogram(),
        SphericalVariogram(range=2.), CubicVariogram(),
        PentasphericalVariogram(), SineHoleVariogram()]

  # non-stationary variogram models
  γn = [PowerVariogram(), PowerVariogram(exponent=.4)]

  # non-decreasing variogram models
  γnd = [GaussianVariogram(), ExponentialVariogram(),
         MaternVariogram(), SphericalVariogram(),
         SphericalVariogram(range=2.), CubicVariogram(),
         PentasphericalVariogram(), PowerVariogram()]

  # check stationarity
  @test all(isstationary(γ) for γ ∈ γs)
  @test all(!isstationary(γ) for γ ∈ γn)

  # variograms are symmetric under Euclidean distance
  for γ ∈ (γs ∪ γn ∪ γnd ∪ [CompositeVariogram(γs..., γn..., γnd...)])
    @test γ(x, y) ≈ γ(y, x)
  end

  # some variograms are non-decreasing
  for γ ∈ (γnd ∪ [CompositeVariogram(γnd...)])
    @test all(γ(h) .≤ γ(h+1))
  end

  # variograms are valid at the origin
  for γ ∈ (γs ∪ γn ∪ γnd)
    @test !isnan(γ(0.)) && !isinf(γ(0.))
  end

  if ismaintainer || istravis
    @testset "Plot recipe" begin
      function plot_variograms(fname)
        plt1 = plot()
        for γ ∈ γs
          plot!(plt1, γ, maxlag=3.)
        end
        plt2 = plot()
        for γ ∈ γn
          plot!(plt2, γ, maxlag=3.)
        end
        plot(plt1, plt2, size=(600,800), layout=(2,1))
        png(fname)
      end
      refimg = joinpath(datadir,"TheoreticalVariograms.png")
      @test test_images(VisualTest(plot_variograms, refimg), popup=!istravis) |> success
    end
  end
end
