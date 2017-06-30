@testset "Distances" begin
  # basic distance properties
  a, b, c = rand(2), rand(2), rand(2)
  for d in [EuclideanDistance(), EllipsoidDistance([1.,.5],[π/4])]
    # positiveness
    @test d(a, b) ≥ 0.
    @test d(a, a) ≈ 0.

    # symmetry
    @test d(a, b) ≈ d(b, a)

    # triangle inequality
    @test d(a, c) ≤ d(a, b) + d(b, c)
  end

  # Euclidean distance
  d = EuclideanDistance()
  @test d([1.,1.,0.], [0.,0.,0.]) ≈ √2
  @test d([-1.,1.,0.], [0.,0.,0.]) ≈ √2

  # ellipsoid distance
  d = EllipsoidDistance([1.,.5,.5], [π/4,0.,0.])
  @test d([1.,1.,0.], [0.,0.,0.]) ≈ √2
  @test d([-1.,1.,0.], [0.,0.,0.]) ≈ √8
end
