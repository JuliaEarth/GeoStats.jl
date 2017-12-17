using PkgBenchmark

function ask_version()
  print("What version would you like to compare to? ")
  String(chomp(strip(readline(STDIN))))
end

results = judge("GeoStats", ask_version())

showall(PkgBenchmark.benchmarkgroup(results))

println()
