#' Plot the result of Precision-Recall curve validation
#'
#' The \code{plot_eval_results} function validate Precision-Recall curves
#'    and creat a plot.
#'
#' @param testdat_names A character vector to specify the names of test data
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
#' plot_eval_results()
#'
#' @export
plot_eval_results <- function(testdat_names = c("r1", "r2", "r3"),
                              toolset_name = "crv",  base_plot = TRUE,
                              ret_grob = FALSE) {

  testsets <- lapply(testdat_names, .get_testdat)
  names(testsets) <- testdat_names

  pointsets <- .create_points(testsets, testdat_names)

  toolset <- create_tools(toolset_name)

  curves <- .create_curves(toolset, testsets, testdat_names)

  eval_res <- .summarize_eval_curves(testdat_names, testsets, toolset_name)

  plots <- .create_plots(pointsets, curves, toolset, eval_res)
  if (base_plot) {
    bplot <- .plot_base(pointsets)
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
# Get points from test datasets
#
.create_points <- function(testsets, testdat_names) {
  pfunc <- function(i) {
    ds <- data.frame(x = testsets[[i]]$bp_x, y = testsets[[i]]$bp_y)
    ds$testdat <- testdat_names[i]
    ds
  }
  pointsets <- do.call(rbind, lapply(seq_along(testsets), pfunc))
  pointsets$testdat <- factor(pointsets$testdat)
  pointsets
}

#
# Create curves by specified tools for test datasets
#
.create_curves <- function(toolset, testsets, testdat_names) {
  cfunc <- function(i) {
    prcdata <- PRCData$new(testsets[[i]]$scores, testsets[[i]]$labels,
                           testdat_names[i])
    tres <- lapply(toolset, function(t) t(prcdata))
    sfunc <- function(tname) {
      tdf <- data.frame(x = tres[[tname]]$get_x(), y = tres[[tname]]$get_y())
      tdf$modname <- tname
      tdf
    }
    df <- do.call(rbind, lapply(names(toolset), sfunc))
    df$testset <- testdat_names[i]
    df
  }
  curves <- do.call(rbind, lapply(seq_along(testsets), cfunc))
  curves$modname <- factor(curves$modname)
  curves$testset <- factor(curves$testset)
  curves
}

#
# Summrize curve evaluation results
#
.summarize_eval_curves <- function(testdat_names, testsets, toolset_name) {
  eres <- eval_curves(testdat_names, toolset_name)
  sum_res <- aggregate(eres[,c('success', 'total')],
                       by = list(eres$tool, eres$testset, eres$toolset),
                       FUN = sum, na.rm = TRUE)
  colnames(sum_res)[1:3] <- c("tool", "testset", "toolset")
  sum_res$label <- factor(paste0(sum_res$success, "/", sum_res$total))
  sum_res$x <- 0
  sum_res$y <- 0
  for (tname in testdat_names) {
    sum_res[sum_res$testset == tname, "x"] <- testsets[[tname]]$tp_x
    sum_res[sum_res$testset == tname, "y"] <- testsets[[tname]]$tp_y
  }

  sum_res
}

#
# Create a list of ggplot objects
#
.create_plots <- function(pointsets, curves, toolset, eval_res) {
  plotfunc <- function(tname) {
    tcurves <- curves[curves$modname == tname, ]
    eres <- eval_res[eval_res$tool == tname, ]
    .plot_curves(pointsets, tcurves, tname, eres)
  }
  plots <- lapply(names(toolset), plotfunc)
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
                                                   colour = "testdat",
                                                   shape = "testdat"),
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
.plot_curves <- function(pointsets, curves, tool_name, eres, yintercept = 0.5) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("ggplot2 needed for this function to work. Please install it.",
         call. = FALSE)
  }
  p <- .plot_base(pointsets, tool_name, yintercept)
  p <- p + ggplot2::geom_line(data = curves,
                              ggplot2::aes_string(x = "x", y = "y",
                                                  colour = "testset"))
  p <- p + ggplot2::geom_text(data = eres,
                              ggplot2::aes_string(x = "x", y = "y",
                                                  label = "label",
                                                  colour = "testset"))
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
