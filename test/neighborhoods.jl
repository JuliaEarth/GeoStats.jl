@testset "Neighborhoods" begin
  @testset "CubeNeighborhood" begin
    @testset "1D regular grid" begin
      grid1D = RegularGrid{Float64}(100)
      neigh1 = GeoStats.CubeNeighborhood(grid1D, .5)
      @test neigh1(1) == [1]
    end
    @testset "2D regular grid" begin
      grid2D = RegularGrid{Float64}(100,100)
      neigh1 = GeoStats.CubeNeighborhood(grid2D, 1.)
      @test neigh1(1) == [1,2,101,102]
      neigh2 = GeoStats.CubeNeighborhood(grid2D, 2.)
      @test neigh2(1) == [1,2,3,101,102,103,201,202,203]
    end
    @testset "3D regular grid" begin
      grid3D = RegularGrid{Float64}(100,100,100)
      neigh1 = GeoStats.CubeNeighborhood(grid3D, .5)
      @test neigh1(1) == [1]
    end
    @testset "4D regular grid" begin
      grid4D = RegularGrid{Float64}(10,20,30,40)
      neigh1 = GeoStats.CubeNeighborhood(grid4D, .5)
      @test neigh1(1) == [1]
    end
    @testset "2D point set" begin
      pc2D = PointSet([0. 1. 0. 1.; 0. 0. 1. 1.])
      neigh1 = GeoStats.CubeNeighborhood(pc2D, 1.)
      @test neigh1(1) == [1,2,3,4]
    end
  end

  @testset "BallNeighborhood" begin
    @testset "1D regular grid" begin
      grid1D = RegularGrid{Float64}(100)
      neigh1 = GeoStats.BallNeighborhood(grid1D, .5)
      @test neigh1(1) == [1]
    end
    @testset "2D regular grid" begin
      grid2D = RegularGrid{Float64}(100,100)
      neigh1 = GeoStats.BallNeighborhood(grid2D, 1.)
      @test neigh1(1) == [1,2,101]
      neigh2 = GeoStats.BallNeighborhood(grid2D, .5)
      @test neigh2(1) == [1]
    end
    @testset "3D regular grid" begin
      grid3D = RegularGrid{Float64}(100,100,100)
      neigh1 = GeoStats.BallNeighborhood(grid3D, .5)
      @test neigh1(1) == [1]
    end
    @testset "4D regular grid" begin
      grid4D = RegularGrid{Float64}(10,20,30,40)
      neigh1 = GeoStats.BallNeighborhood(grid4D, .5)
      @test neigh1(1) == [1]
    end
    @testset "2D point set" begin
      pc2D = PointSet([0. 1. 0. 1.; 0. 0. 1. 1.])
      neigh1 = GeoStats.BallNeighborhood(pc2D, 1.)
      @test neigh1(1) == [1,2,3]
    end
  end
end
