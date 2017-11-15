@testset "Comparisons" begin
  grid2D = RegularGrid{Float64}(100,100)
  problem2D = EstimationProblem(data2D, grid2D, :value)
  solver₁ = Kriging(:value => @NT(variogram=GaussianVariogram(range=35.)))
  solver₂ = Kriging(:value => @NT(variogram=SphericalVariogram(range=35.)))

  @testset "Visual comparison" begin
    if ismaintainer || istravis
      function plot_comparison(fname)
        compare([solver₁, solver₂], problem2D, VisualComparison())
        png(fname)
      end
      refimg = joinpath(datadir,"VisualComparison.png")
      @test test_images(VisualTest(plot_comparison, refimg), popup=!istravis) |> success
    end
  end
end
