#
# ROCR
#
.rocr_wrapper <- function(sdat, retval = TRUE, auc = FALSE) {
  if (!requireNamespace("ROCR", quietly = TRUE)) {
    stop("ROCR needed for this function to work. Please install it.",
         call. = FALSE)
  }

  # Prepare data
  scores <- sdat$get_scores()
  labels <- sdat$get_labels()

  # Calculate Precison-Recall curve
  pred <- ROCR::prediction(scores, labels)
  perf <- ROCR::performance(pred, "prec", "rec")

  # Get AUC
  if (auc) {
    x <- slot(perf, "x.values")[[1]]
    y <- slot(perf, "y.values")[[1]]

    # Copied the logic from .performance.auc of ROCR
    aucscore <- 0
    for (i in 2:length(x)) {
      aucscore <- aucscore + 0.5 * (x[i] - x[i-1]) * (y[i] + y[i-1])
    }

  } else {
    aucscore <- NA
  }

  # Return x and y values if requested
  if (retval) {
    x <- slot(perf, "x.values")[[1]]
    y <- slot(perf, "y.values")[[1]]

    list(x = x, y = y, auc = aucscore)
  } else {
    NULL
  }
}

#
# PerfMeas
#
.pm_wrapper <- function(sdat, retval = TRUE, auc = FALSE) {
  if (!requireNamespace("PerfMeas", quietly = TRUE)) {
    stop("PerfMeas needed for this function to work. Please install it.",
         call. = FALSE)
  }

  # Prepare data
  scores <- sdat$get_scores()
  labels <- sdat$get_labels()

  # Calculate Precison-Recall curve
  prc <- PerfMeas::precision.at.all.recall.levels(scores, labels)

  # Get AUC
  if (auc) {
    aucscore <- PerfMeas::AUPRC(list(prc), comp.precision = TRUE)
  } else {
    aucscore <- NA
  }

  # Return x and y values if requested
  if (retval) {
    x <- prc[["recall"]]
    y <- prc[["precision"]]

    list(x = x, y = y, auc = aucscore)
  } else {
    NULL
  }
}

#
# PRROC
#
.prroc_wrapper <- function(sdat, retval = TRUE, auc = FALSE,
                          curve = TRUE, minStepSize = 0.01) {
  if (!requireNamespace("PRROC", quietly = TRUE)) {
    stop("PRROC needed for this function to work. Please install it.",
         call. = FALSE)
  }

  # Prepare data
  fg <- sdat$get_fg()
  bg <- sdat$get_bg()

  # Calculate Precison-Recall curve
  prc <- PRROC::pr.curve(fg, bg, curve = curve, minStepSize = minStepSize)

  # Get AUC
  if (auc) {
    aucscore <- prc$auc.integral
  } else {
    aucscore <- NA
  }

  # Return x and y values if requested
  if (retval) {
    x <- rev(prc[["curve"]][, 1])
    y <- rev(prc[["curve"]][, 2])

    list(x = x, y = y, auc = aucscore)
  } else {
    NULL
  }
}

#
# precrec
#
.precrec_wrapper <- function(sdat, retval = TRUE, auc = FALSE) {
  if (!requireNamespace("precrec", quietly = TRUE)) {
    stop("precrec needed for this function to work. Please install it.",
         call. = FALSE)
  }

  # Prepare data
  scores <- sdat$get_scores()
  labels <- sdat$get_labels()

  # Calculate Precison-Recall curve
  curves <- precrec::evalmod(scores = scores, labels = labels)

  # Get AUC
  if (auc) {
    aucs <- precrec::auc(curves)
    aucscore <-  subset(aucs, curvetypes == "PRC")
  } else {
    aucscore <- NA
  }

  # Return x and y values if requested
  if (retval) {
    x <- curves[["prcs"]][[1]][["x"]]
    y <- curves[["prcs"]][[1]][["y"]]

    list(x = x, y = y, auc = aucscore)
  } else {
    NULL
  }
}
