#' Plot the result of Precision-Recall curve evaluation
#'
#' The \code{plot_eval_results} function validates Precision-Recall curves
#'    and creates a plot.
#'
#' @param object An S3 object that contains evaluation results of
#'     Precision-Recall curves.
#'
#' @param base_plot A Boolean value to specify whether the base points are
#'     plotted.
#'
#' @param ncol An integer used for the column size of multiple panes.
#'
#' @param nrow An integer used for the row size of multiple panes.
#'
#' @param ret_grob A Boolean value to specify whether the function returns a
#'     grob object.
#'
#' @param use_category A Boolean value to specify whether the categorical
#'     summary instead of the total summary.
#'
#' @param multiplot_lib A string to decide which library is used to combine
#'    multiple plots. Either "patchwork" or "grid".
#'
#' @param ... Not used by this function.
#'
#' @return A data frame with validation results.
#'
#' @examples
#' library(ggplot2)
#'
#' ## Plot evaluation results on test datasets r1, r2, and r3
#' testset <- create_testset("curve", c("c1", "c2", "c3"))
#' toolset <- create_toolset(set_names = "crv5")
#' eres1 <- run_evalcurve(testset, toolset)
#' autoplot(eres1)
#'
#' @name autoplot
#' @export
NULL

#' @rdname autoplot
#' @export
autoplot.evalcurve <- function(object, base_plot = TRUE, ret_grob = FALSE,
                               ncol = NULL, nrow = NULL, use_category = FALSE,
                               multiplot_lib = "patchwork", ...) {
  .load_ggplot2()

  # Validate arguments
  new_args <- .validate_autoplot_evalcurve_args(
    object, base_plot, ret_grob,
    ncol, nrow, use_category,
    multiplot_lib, ...
  )

  # Create plots
  plots <- .create_plots(new_args$object, use_category)
  if (new_args$base_plot) {
    bplot <- .plot_base(object$basepoints)
    plots <- c(list(bplot), plots)
  }

  # Combine multiple plots
  ncolrow <- .get_row_col(new_args$ncol, new_args$nrow, length(plots))

  .combine_plots(plots, new_args, ncolrow$ncol, ncolrow$nrow)
}

#
# Load ggplot2
#
.load_ggplot2 <- function() {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    msg <- "ggplot2 is required to run this funcion"
    stop(msg, call. = FALSE)
  }
}

#
# Load grid
#
.load_grid <- function() {
  if (!requireNamespace("grid", quietly = TRUE)) {
    msg <- "grid is required to run this funcion"
    stop(msg, call. = FALSE)
  }
}

#
# Load gridExtra
#
.load_gridextra <- function() {
  if (!requireNamespace("gridExtra", quietly = TRUE)) {
    msg <- "gridExtra is required to run this funcion"
    stop(msg, call. = FALSE)
  }
}

#
# Load patchwork
#
.load_patchwork <- function() {
  if (requireNamespace("patchwork", quietly = TRUE)) {
    return(TRUE)
  } else {
    msg1 <- "patchwork is not available. "
    msg2 <- "grid and gridExtra will be used instead."
    warning(paste0(msg1, msg2), call. = FALSE)
    return(FALSE)
  }
}

#
# Get the numbers of rows and columns for arrangeGrob
#
.get_row_col <- function(ncol, nrow, nplot) {
  if (is.null(ncol)) {
    if (nplot >= 4) {
      ncol <- 2
    } else {
      ncol <- nplot
    }
  }

  if (is.null(nrow)) {
    if (nplot >= 5) {
      nrow <- 3
    } else if (nplot == 4) {
      nrow <- 2
    } else {
      nrow <- 1
    }
  }

  list(ncol = ncol, nrow = nrow)
}

#
# Create a list of ggplot objects
#
.create_plots <- function(evalcurve, use_category) {
  preds <- evalcurve$predictions
  tscores <- evalcurve$testsum
  uniqnames <- unique(paste(tscores$toolset, tscores$toolname))

  plotfunc <- function(i) {
    unamevec <- strsplit(uniqnames[i], " ")[[1]]
    toolset <- unamevec[1]
    toolname <- unamevec[2]

    pcrows <- (preds$toolset == toolset) & (preds$toolname == toolname)
    pcurves <- preds[pcrows, ]

    tsrows <- (tscores$toolset == toolset) & (tscores$toolname == toolname)
    tscore <- tscores[tsrows, ]

    .plot_curves(
      evalcurve$basepoints, pcurves, tscore,
      toolname, use_category
    )
  }

  lapply(seq_along(uniqnames), plotfunc)
}


#
# Plot base points
#
.plot_base <- function(basepoints, title = "Base points",
                       yintercept = 0.5) {
  p <- ggplot2::ggplot()
  p <- p + ggplot2::geom_hline(
    yintercept = yintercept, colour = "grey",
    linetype = 3
  )
  p <- p + ggplot2::geom_point(
    data = basepoints,
    ggplot2::aes_string(
      x = "x", y = "y",
      colour = "testset",
      shape = "testset"
    ),
    size = 2
  )
  p <- p + ggplot2::scale_shape(solid = FALSE)
  p <- p + ggplot2::theme_bw()
  p <- p + ggplot2::ggtitle(title)
  p <- p + ggplot2::xlab("recall")
  p <- p + ggplot2::ylab("precision")
  p <- p + ggplot2::theme(legend.title = ggplot2::element_blank())
  p <- p + ggplot2::theme(legend.position = "none")
  p <- p + ggplot2::scale_y_continuous(limits = c(0.0, 1.0))
  p <- p + ggplot2::coord_fixed(ratio = 1)
}

#
# Plot curves for a specified tool
#
.plot_curves <- function(basepoints, pcurves, tscore, toolname,
                         use_category, yintercept = 0.5) {
  p <- .plot_base(basepoints, toolname, yintercept)
  p <- p + ggplot2::geom_line(
    data = pcurves,
    ggplot2::aes_string(
      x = "x", y = "y",
      colour = "testset"
    )
  )

  if (use_category) {
    p <- p + ggplot2::geom_label(
      data = tscore,
      size = 3,
      colour = "white",
      fontface = "bold",
      alpha = 0.75,
      ggplot2::aes_string(
        x = "lbl_pos_x2",
        y = "lbl_pos_y2",
        label = "label2",
        fill = "testset"
      )
    )
  } else {
    p <- p + ggplot2::geom_label(
      data = tscore,
      ggplot2::aes_string(
        x = "lbl_pos_x",
        y = "lbl_pos_y",
        label = "label",
        color = "testset"
      )
    )
  }
}

#
# Plot curves for a specified tool with grid and gridExtra
#
.combine_plots_grid <- function(plots, ncol, nrow) {
  if (!requireNamespace("gridExtra", quietly = TRUE)) {
    stop("gridExtra needed for this function to work. Please install it.",
      call. = FALSE
    )
  }

  gfunc <- function(...) {
    gridExtra::arrangeGrob(..., ncol = ncol, nrow = nrow)
  }
  suppressWarnings(do.call(gfunc, plots))
}

#
# Combine ROC and Precision-Recall plots by patchwork
#
.combine_plots_patchwork <- function(plots, ncol, nrow) {
  patchwork::wrap_plots(plots, ncol = ncol, nrow = nrow)
}

#
# Combine ROC and Precision-Recall plots
#
.combine_plots <- function(plots, args, ncol, nrow) {
  multiplot_lib <- args$multiplot_lib
  if (multiplot_lib == "patchwork") {
    if (.load_patchwork()) {
      return(.combine_plots_patchwork(plots, ncol, nrow))
    } else {
      multiplot_lib <- "grid"
    }
  }
  if (multiplot_lib == "grid") {
    .load_grid()
    .load_gridextra()
    ggrob <- .combine_plots_grid(plots, ncol, nrow)
    if (args$ret_grob) {
      return(ggrob)
    } else {
      .plot_grob(ggrob)
    }
  }
}

#
# Plot grob object
#
.plot_grob <- function(grob) {
  if (!requireNamespace("grid", quietly = TRUE)) {
    stop("grid needed for this function to work. Please install it.",
      call. = FALSE
    )
  }
  graphics::plot.new()
  grid::grid.draw(grob)
}

#
# Validate arguments and return updated arguments
#
.validate_autoplot_evalcurve_args <- function(object, base_plot, ret_grob, ncol,
                                              nrow, use_category, multiplot_lib,
                                              ...) {
  if (!methods::is(object, "evalcurve")) {
    stop("Ivalid object type", call. = FALSE)
  }

  assertthat::assert_that(assertthat::is.flag(base_plot))
  assertthat::assert_that(assertthat::is.flag(ret_grob))

  if (!is.null(ncol) && !is.null(nrow)) {
    assertthat::assert_that(assertthat::is.number(ncol))
    assertthat::assert_that(ncol > 0)

    assertthat::assert_that(assertthat::is.number(nrow))
    assertthat::assert_that(nrow > 0)
  } else if ((!is.null(ncol) && is.null(nrow)) ||
    (is.null(ncol) && !is.null(nrow))) {
    stop("Both ncol and nrow must be set", call. = FALSE)
  }

  assertthat::assert_that(assertthat::is.flag(use_category))

  assertthat::assert_that(
    is.atomic(multiplot_lib),
    is.character(multiplot_lib),
    multiplot_lib %in% c("patchwork", "grid")
  )

  list(
    object = object, base_plot = base_plot, ret_grob = ret_grob, ncol = ncol,
    nrow = nrow, use_category = use_category, multiplot_lib = multiplot_lib
  )
}
