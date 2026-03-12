#!/usr/bin/env Rscript
# Basic plot validation - checks if code produces ggplot object
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Usage: Rscript plot-validator.R <code_file.R>")
}

code_file <- args[1]

library(jsonlite)
library(ggplot2)

tryCatch({
  # Source the code and capture result
  result_obj <- source(code_file, keep.source = FALSE)
  last_val <- result_obj$value

  # Check if last value is ggplot
  is_ggplot <- !is.null(last_val) && inherits(last_val, "ggplot")

  result <- list(
    valid = is_ggplot,
    message = if (is_ggplot) "Valid ggplot object" else "No ggplot object found"
  )

  if (is_ggplot) {
    # Additional checks
    result$layers <- length(last_val$layers)
    result$has_title <- !is.null(last_val$labels$title)
  }

  cat(toJSON(result, auto_unbox = TRUE))
}, error = function(e) {
  cat(toJSON(list(valid = FALSE, error = as.character(e$message)), auto_unbox = TRUE))
})
