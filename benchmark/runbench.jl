using PkgBenchmark

results = judge("GeoStats","v0.4.4")

showall(PkgBenchmark.benchmarkgroup(results))
