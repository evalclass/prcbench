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
# Check whether the standalone Python module can be used
#
.check_sklearn_available <- function() {
  if (!requireNamespace("reticulate", quietly = TRUE)) {
    return(FALSE)
  }
  if (!reticulate::py_available(initialize = TRUE)) {
    return(FALSE)
  }
  if (!reticulate::py_module_available("numpy")) {
    return(FALSE)
  }

  isTRUE(tryCatch(
    {
      .sklearn_module()
      TRUE
    },
    error = function(e) FALSE
  ))
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
