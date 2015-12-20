#' Plot the result of Precision-Recall curve validation
#'
#' The \code{plot_eval_results} function validate Precision-Recall curves
#'    and creat a plot.
#'
#' @param testdata_names A character vector to specify the names of test data
#'     sets.
#'
#' @param toolset_name A single string to specify the name of tool sets.
#'
#' @param base_plot A Boolean value to specify whether the base points are
#'     plotted.
#'
#' @param ret_grob A Boolean value to specify whether the function returs a
#'     grob object.
#'
#' @return A data frame with validation results.
#'
#' @examples
#' ## Plot evaluation results on test datasets r1, r2, and r3
#' eres1 <- eval_curves(c("r1", "r2", "r3"), "crv")
#' plot_eval_results(eres1)
#'
#' @export
plot_eval_results <- function(eval_res,  base_plot = TRUE, ret_grob = FALSE) {

  plots <- .create_plots(eval_res)
  if (base_plot) {
    bplot <- .plot_base(eval_res$points)
    plots <- c(list(bplot), plots)
  }

  ggrob <- .combine_plots(plots)

  if (ret_grob) {
    return(ggrob)
  } else {
    .plot_grob(ggrob)
  }

}

#
# Create a list of ggplot objects
#
.create_plots <- function(eval_res) {
  plotfunc <- function(tname) {
    tcurves <- eval_res$curves[eval_res$curves$modname == tname, ]
    eres <- eval_res$scores[eval_res$scores$tool == tname, ]
    .plot_curves(eval_res$points, tcurves, eres, tname)
  }
  plots <- lapply(unique(eval_res$scores$tool), plotfunc)
}

#
# Plot base points
#
.plot_base <- function(pointsets, title = "Base points", yintercept = 0.5) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("ggplot2 needed for this function to work. Please install it.",
         call. = FALSE)
  }

  p <- ggplot2::ggplot()
  p <- p + ggplot2::geom_hline(yintercept = yintercept, colour = "grey",
                               linetype = 3)
  p <- p + ggplot2::geom_point(data = pointsets,
                               ggplot2::aes_string(x = "x", y = "y",
                                                   colour = "testdata",
                                                   shape = "testdata"),
                               size = 2)
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
.plot_curves <- function(pointsets, curves, eres, tool_name, yintercept = 0.5) {
  p <- .plot_base(pointsets, tool_name, yintercept)
  p <- p + ggplot2::geom_line(data = curves,
                              ggplot2::aes_string(x = "x", y = "y",
                                                  colour = "testdata"))
  p <- p + ggplot2::geom_text(data = eres,
                              ggplot2::aes_string(x = "x", y = "y",
                                                  label = "label",
                                                  colour = "testdata"))
}

#
# Plot curves for a specified tool
#
.combine_plots <- function(plots, ncol = 2, nrow = 3) {
  if (!requireNamespace("gridExtra", quietly = TRUE)) {
    stop("gridExtra needed for this function to work. Please install it.",
         call. = FALSE)
  }

  gfunc <- function(...) {gridExtra::arrangeGrob(..., ncol = ncol, nrow = nrow)}
  grob <- do.call(gfunc, plots)
}

#
# Plot grob object
#
.plot_grob <- function(grob) {
  if (!requireNamespace("grid", quietly = TRUE)) {
    stop("grid needed for this function to work. Please install it.",
         call. = FALSE)
  }
  graphics::plot.new()
  grid::grid.draw(grob)
}
