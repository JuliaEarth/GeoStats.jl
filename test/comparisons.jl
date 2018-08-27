@testset "Comparisons" begin
  grid2D = RegularGrid{Float64}(100,100)
  problem2D = EstimationProblem(data2D, grid2D, :value)
  solver₁ = Kriging(:value => (variogram=GaussianVariogram(range=35.),))
  solver₂ = Kriging(:value => (variogram=SphericalVariogram(range=35.),))

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

  @testset "Cross-validation" begin
    result = compare([solver₁, solver₂], problem2D, CrossValidation(3))
    errors4var = result.errors4var

    # data set with 3 points + 3-fold CV => 3 error values per solver
    @test length(errors4var[:value][1]) == 3
    @test length(errors4var[:value][2]) == 3

    # number of folds must be smaller than number of points, throw an error
    @test_throws AssertionError compare([solver₁, solver₂], problem2D, CrossValidation())
  end
end
