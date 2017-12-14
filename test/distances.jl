@testset "Distances" begin
  dist = Ellipsoidal([1.,.5,.5], [π/4,0.,0.])
  @test evaluate(dist, [1.,1.,0.], [0.,0.,0.]) ≈ √2
  @test evaluate(dist, [-1.,1.,0.], [0.,0.,0.]) ≈ √8
end
