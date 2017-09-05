@testset "Mappers" begin
  @testset "SimpleMapper" begin
    @testset "RegularGrid" begin
      grid1D = RegularGrid{Float64}(100)
      mapper1D = GeoStats.SimpleMapper(data1D, grid1D, Dict(:value => Float64))
      @test GeoStats.mapping(mapper1D, :value) == Dict(71=>0.3,91=>0.1,31=>0.3,81=>0.2,61=>0.4,11=>0.1,51=>0.5,21=>0.2,41=>0.4,1=>0.0)

      grid2D = RegularGrid{Float64}(100,100)
      mapper2D = GeoStats.SimpleMapper(data2D, grid2D, Dict(:value => Float64))
      @test GeoStats.mapping(mapper2D, :value) == Dict(5076=>1.0,2526=>1.0,7551=>0.0)
    end
    @testset "PointCollection" begin
      pc2D = PointCollection([25. 50. 75.; 25. 75. 50.])
      mapper2D = GeoStats.SimpleMapper(data2D, pc2D, Dict(:value => Float64))
      @test GeoStats.mapping(mapper2D, :value) == Dict(2=>0.0,3=>1.0,1=>1.0)
    end
  end
end
