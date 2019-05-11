@testset "Comparisons" begin
  @testset "Visual comparison" begin
    data2D = readgeotable(joinpath(datadir,"data2D.tsv"), delim='\t', coordnames=[:x,:y])
    grid2D = RegularGrid{Float64}(100,100)
    problem2D = EstimationProblem(data2D, grid2D, :value)

    solver₁ = Kriging(:value => (variogram=GaussianVariogram(range=35.),))
    solver₂ = Kriging(:value => (variogram=SphericalVariogram(range=35.),))

    if visualtests
      @plottest begin
        gr(size=(600,400))
        Random.seed!(123)
        compare([solver₁, solver₂], problem2D, VisualComparison())
      end joinpath(datadir,"VisualComparison.png") !istravis
    end
  end

  @testset "Cross-validation" begin
    data2D = readgeotable(joinpath(datadir,"data2D.tsv"), delim='\t', coordnames=[:x,:y])
    grid2D = RegularGrid{Float64}(100,100)
    problem2D = EstimationProblem(data2D, grid2D, :value)

    solver₁ = Kriging(:value => (variogram=GaussianVariogram(range=20.),))
    solver₂ = Kriging(:value => (variogram=SphericalVariogram(range=20.),))

    result = compare([solver₁, solver₂], problem2D, CrossValidation(3))
    errors = result.errors

    # data set with 3 points + 3-fold CV => 3 error values per solver
    @test length(errors[:value][1]) == 3
    @test length(errors[:value][2]) == 3

    # number of folds must be smaller than number of points, throw an error
    @test_throws AssertionError compare([solver₁, solver₂], problem2D, CrossValidation(10))

    Random.seed!(2019)

    data2D = readgeotable(joinpath(datadir,"500Gaussian.csv"), coordnames=[:x,:y])
    grid2D = boundgrid(data2D, (100,100))
    problem2D = EstimationProblem(data2D, grid2D, :value)

    if visualtests
      @plottest begin
        gr(size=(600,400))
        result = compare([solver₁, solver₂], problem2D, CrossValidation(10))
        plot(result, bins=50)
      end joinpath(datadir,"CrossValidation.png") !istravis
    end
  end
end
