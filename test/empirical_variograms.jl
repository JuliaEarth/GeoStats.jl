@testset "Empirical variograms" begin
  # homogeneous field has zero variogram
  γ = EmpiricalVariogram(eye(3), ones(3), nbins=2, maxlag=2.)
  x, y, n = values(γ)
  @test x ≈ [1/2, 3/2]
  @test isnan(y[1]) && y[2] == 0.
  @test n == [0, 3]

  # test geodataframe interface
  γ = EmpiricalVariogram(data2D, :value, nbins=20, maxlag=1.)
  x, y, n = values(γ)
  @test length(x) == 20
  @test length(y) == 20
  @test length(n) == 20

  # empirical variogram on integer coordinates
  γ = EmpiricalVariogram(eye(Int, 3), ones(3), nbins=2, maxlag=2)
  x, y, n = values(γ)
  @test x ≈ [1/2, 3/2]
  @test isnan(y[1]) && y[2] == 0.
  @test n == [0, 3]

  if ismaintainer || istravis
    @testset "Plot recipe" begin
      function plot_variograms(fname)
        TI = training_image("WalkerLake")[1:20,1:20,1]
        x = Float64[i for i=1:20 for j=1:20]
        y = Float64[j for i=1:20 for j=1:20]
        v = Float64[TI[i,j] for i=1:20 for j=1:20]
        plot(EmpiricalVariogram(hcat(x,y)', v))
        png(fname)
      end
      refimg = joinpath(datadir,"EmpiricalVariograms.png")
      @test test_images(VisualTest(plot_variograms, refimg), popup=!istravis) |> success
    end
  end
end
