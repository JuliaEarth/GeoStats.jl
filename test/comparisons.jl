@testset "Comparisons" begin
  @testset "Visual comparison" begin
    data2D = readgeotable(joinpath(datadir,"data2D.tsv"), delim='\t', coordnames=[:x,:y])
    grid2D = RegularGrid{Float64}(100,100)
    problem2D = EstimationProblem(data2D, grid2D, :value)

    solver₁ = Kriging(:value => (variogram=GaussianVariogram(range=35.),))
    solver₂ = Kriging(:value => (variogram=SphericalVariogram(range=35.),))

    if ismaintainer || istravis
      function plot_comparison(fname)
        compare([solver₁, solver₂], problem2D, VisualComparison())
        png(fname)
      end
      refimg = joinpath(datadir,"VisualComparison.png")
      @test test_images(VisualTest(plot_comparison, refimg), popup=!istravis, tol=0.1) |> success
    end
  end

  @testset "Cross-validation" begin
    data2D = readgeotable(joinpath(datadir,"data2D.tsv"), delim='\t', coordnames=[:x,:y])
    grid2D = RegularGrid{Float64}(100,100)
    problem2D = EstimationProblem(data2D, grid2D, :value)

    solver₁ = Kriging(:value => (variogram=GaussianVariogram(range=40.),))
    solver₂ = Kriging(:value => (variogram=SphericalVariogram(range=20.),))

    result = compare([solver₁, solver₂], problem2D, CrossValidation(3))
    errors = result.errors

    # data set with 3 points + 3-fold CV => 3 error values per solver
    @test length(errors[:value][1]) == 3
    @test length(errors[:value][2]) == 3

    # number of folds must be smaller than number of points, throw an error
    @test_throws AssertionError compare([solver₁, solver₂], problem2D, CrossValidation(10))

    Random.seed!(2019)

    data2D = readgeotable(joinpath(datadir,"500points.csv"), coordnames=[:x,:y])
    grid2D = boundgrid(data2D, (100,100))
    problem2D = EstimationProblem(data2D, grid2D, :value)

    if ismaintainer || istravis
      function plot_comparison(fname)
        result = compare([solver₁, solver₂], problem2D, CrossValidation(10))
        plot(result, bins=50)
        png(fname)
      end
      refimg = joinpath(datadir,"CrossValidationn.png")
      @test test_images(VisualTest(plot_comparison, refimg), popup=!istravis, tol=0.1) |> success
    end
  end
end
