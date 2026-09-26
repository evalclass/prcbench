#
# scikit-learn
#

# Cache for the imported Python module. Importing is relatively expensive and
# run_benchmark times repeated calls of the wrapper, so the module must be
# imported once and reused rather than on every call.
.sklearn_cache <- new.env(parent = emptyenv())

#
# Load reticulate
#
.load_reticulate <- function() {
  if (!requireNamespace("reticulate", quietly = TRUE)) {
    msg <- "reticulate is required to run this funcion"
    stop(msg, call. = FALSE)
  }
}

#
# Environment variables that size the thread pool of the BLAS library behind
# numpy
#
.sklearn_thread_vars <- c(
  "OMP_NUM_THREADS", "OPENBLAS_NUM_THREADS", "MKL_NUM_THREADS",
  "NUMEXPR_NUM_THREADS"
)

#
# Evaluate expr with the numpy thread pool capped
#
# Initialising Python imports numpy, and the BLAS library behind it starts a
# thread pool sized to the number of cores. The pool costs CPU time that the
# initialisation never spends, so on a machine with many cores the CPU time of
# the import is several times its elapsed time. CRAN allows two cores, so the
# pool is capped to two here. Variables the user has already set are left
# alone, and the ones set here are removed again afterwards: the pool is
# created during the import and keeps its size for the session, so the cap has
# to be in place for the import only.
#
.with_capped_threads <- function(expr, nthreads = 2) {
  unset <- .sklearn_thread_vars[!nzchar(Sys.getenv(.sklearn_thread_vars))]
  if (length(unset) > 0) {
    vals <- as.list(rep(as.character(nthreads), length(unset)))
    names(vals) <- unset
    do.call(Sys.setenv, vals)
    on.exit(Sys.unsetenv(unset), add = TRUE)
  }

  force(expr)
}

#
# Check whether the standalone Python module can be used
#
.check_sklearn_available <- function() {
  if (!requireNamespace("reticulate", quietly = TRUE)) {
    return(FALSE)
  }

  .with_capped_threads(
    reticulate::py_available(initialize = TRUE) &&
      reticulate::py_module_available("numpy") &&
      isTRUE(tryCatch(
        {
          .sklearn_module()
          TRUE
        },
        error = function(e) FALSE
      ))
  )
}

#
# Cached version of .check_sklearn_available
#
# run_benchmark times repeated calls of the wrapper, so the check and the
# import it performs must happen before the first timed call rather than
# inside it. The result is kept for the session.
#
.sklearn_available <- function() {
  if (is.null(.sklearn_cache$available)) {
    .sklearn_cache$available <- .check_sklearn_available()
  }

  .sklearn_cache$available
}

#
# Import the standalone Python module bundled in inst/python
#
.sklearn_module <- function() {
  if (!is.null(.sklearn_cache$module)) {
    return(.sklearn_cache$module)
  }

  .load_reticulate()

  pypath <- system.file("python", package = "prcbench")
  if (!nzchar(pypath)) {
    stop("Cannot locate the bundled Python module", call. = FALSE)
  }

  module <- reticulate::import_from_path("prcbench_sklearn", path = pypath)
  .sklearn_cache$module <- module

  module
}

#
# scikit-learn wrapper
#
.sklearn_wrapper <- function(testset, calc_auc = FALSE, store_res = TRUE,
                             drop_intermediate = FALSE, aucType = 1) {
  # Prepare data
  scores <- testset$get_scores()
  labels <- testset$get_labels()

  # The positive label follows the same convention as the other tools
  pos_label <- max(unique(labels))

  # Calculate Precision-Recall curve
  skl <- .sklearn_module()
  prc <- skl$prc_curve(
    scores = as.numeric(scores),
    labels = as.numeric(labels),
    pos_label = as.numeric(pos_label),
    drop_intermediate = drop_intermediate,
    auc_type = as.integer(aucType)
  )

  # Get AUC
  if (calc_auc) {
    aucscore <- as.numeric(prc[["auc"]])
    names(aucscore) <- NULL
  } else {
    aucscore <- NA
  }

  # Return x and y values if requested
  if (store_res) {
    x <- as.numeric(prc[["x"]])
    y <- as.numeric(prc[["y"]])

    list(x = x, y = y, auc = aucscore)
  } else {
    NULL
  }
}
