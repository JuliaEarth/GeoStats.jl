@testset "Plotting" begin
  if ismaintainer || istravis
    @testset "h-scatter" begin
      function plot_hscatter(fname)
        hscatter(samples2D, :value, lags=[0.,1.,2.,3.], size=(1000,300))
        png(fname)
      end
      refimg = joinpath(datadir,"HScatter.png")
      @test test_images(VisualTest(plot_hscatter, refimg), popup=!istravis) |> success
    end
  end
end
