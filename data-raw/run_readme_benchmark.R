# Record the running time table that README.Rmd shows.
#
# The readme used to call run_benchmark on every knit. That tied the knit time
# to the largest test set and made the numbers drift on every commit, so a
# rendered readme diff was mostly noise. This script records the result once
# into data-raw/readme_benchmark.csv, and README.Rmd reads that file.
#
# Re-run it when a wrapped tool is added or removed, when one of the wrapped
# packages is updated, or when precrec gets a performance change worth showing.
# Commit the regenerated csv and info file together with the re-knitted readme.
#
#   Rscript data-raw/run_readme_benchmark.R
#
# Run it on an otherwise idle machine. The largest test set takes a few
# minutes, almost all of it in AUCCalculator.

devtools::load_all(quiet = TRUE)

set_name <- "auc7"
testset_names <- c("b100", "b1000", "b10000", "b100000")
times <- 5
out_csv <- "data-raw/readme_benchmark.csv"
out_info <- "data-raw/readme_benchmark_info.dcf"

toolset <- create_toolset(set_names = set_name)

# Warm up first. The JVM of AUCCalculator, the Python interpreter of sklearn
# and the R byte compiler all pay a one off cost on their first call, and
# without this it lands on whichever test set happens to run first.
invisible(utils::capture.output(
  run_benchmark(create_testset("bench", "b100"), toolset, times = 2, unit = "s")
))

res <- run_benchmark(
  create_testset("bench", testset_names), toolset,
  times = times, unit = "s"
)

write.csv(res$tab, out_csv, row.names = FALSE)

pkg_version <- function(pkg) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    as.character(utils::packageVersion(pkg))
  } else {
    "not installed"
  }
}
wrapped <- c("precrec", "ROCR", "PRROC", "yardstick")

info <- c(
  Date = format(Sys.Date()),
  Toolset = set_name,
  Testsets = paste(testset_names, collapse = ", "),
  Times = as.character(times),
  Unit = "seconds",
  R = R.version.string,
  Platform = R.version$platform,
  prcbench = pkg_version("prcbench"),
  Wrapped = paste0(wrapped, " ", vapply(wrapped, pkg_version, character(1)),
    collapse = ", "
  )
)
write.dcf(as.data.frame(as.list(info), stringsAsFactors = FALSE), out_info)

cat("Wrote", out_csv, "and", out_info, "\n")
print(res)
