#
# PerfMeas
#
.pm_wrapper <- function(testset, calc_auc = FALSE, store_res = TRUE) {

  # Prepare data
  scores <- testset$get_scores()
  labels <- testset$get_labels()

  # Calculate Precision-Recall curve
  prc <- .perfmeas.precision.at.all.recall.levels(scores, labels)

  # Get AUC
  if (calc_auc) {
    aucscore <- .perfmeas.AUPRC(list(prc), comp.precision = TRUE)
    names(aucscore) <- NULL
  } else {
    aucscore <- NA
  }

  # Return x and y values if requested
  if (store_res) {
    x <- prc[["recall"]]
    y <- prc[["precision"]]

    list(x = x, y = y, auc = aucscore)
  } else {
    NULL
  }
}

# Function to compute the precision at all recall levels  for a single class
# Input:
#   scores : vector of the predicted scores in [0,1]
#   labels : 0/1 vector of the true labels
# Output:
#   a list with 3 elements:
#   precision : precision at different thresholds
#   recall : recall at different thresholds
#   f.score : f.score at different thresholds
.perfmeas.precision.at.all.recall.levels <- function(scores, labels){
  n <- length(scores);
  if (n!=length(labels)) {
    stop("precision.at.recall.level: length of labels and scores does not match");
  }

  if (length(which(labels > 0)) == 0) {
    return(list(res = 0, precision = rep(0, n), recall = rep(0, n)))
  }

  scores.ordered <- order(scores, decreasing=TRUE);
  precision <- recall <- rep(0, n)
  res <- perfmeas_prec_recall(as.integer(scores.ordered), as.integer(labels), as.integer(n))

  precision <- res[["precision"]]
  recall <- res[["recall"]]

  f.score <- (2 * precision * recall)/(precision + recall)
  f.score[is.nan(f.score)] <- 0

  list(precision = precision, recall = recall, f.score = f.score)
}

# Function to compute multiple AUPRC (Area Under Precision and Recall Curves)
# Input:
#   z : a list of lists. Each component list is a list returned from precision.at.all.recall.levels
#       that reports precision, recall and f-score results at different levels for different methods or tasks
#   comp.precision: boolean. It TRUE (default) the AUPRC is computed otherwise the area under the F-score curve is computed
# Output:
#   a named vector with the AUPRC (or the AUFRC) for different methods or tasks
.perfmeas.AUPRC <- function(z, comp.precision=TRUE) {
  n <- length(z)
  curve.names <- names(z)
  if (is.null(names(curve.names))) {
    curve.names <- as.character(1:n)
  }
  integral <- numeric(n)
  names(integral) <- curve.names
  for (i in 1:n)  {
    if (comp.precision) {
      integral[i] <- .perfmeas.trap.rule.integral(z[[i]][[2]], z[[i]][[1]])
    } else {
      integral[i] <- .perfmeas.trap.rule.integral(z[[i]][[2]], z[[i]][[3]])
    }
  }

  integral
}

# Function that implements the trapezoidal rule for integration
# Input:
#   x : abscissa values in increasing order
#   y : ordinate values
# Output:
#   value of the integral
.perfmeas.trap.rule.integral <- function (x, y) {
  if (length(x) != length(y)) {
    stop("trap.rule.integral: length of x and y vectors must match")
  }

  integral_value = 0.0;

  perfmeas_trap_rule(as.double(x), as.double(y), as.integer(length(x)))
}
