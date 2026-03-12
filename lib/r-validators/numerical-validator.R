#!/usr/bin/env Rscript
# Basic numerical validation - checks if code produces numeric result
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Usage: Rscript numerical-validator.R <code_file.R>")
}

code_file <- args[1]

library(jsonlite)

tryCatch({
  result_obj <- source(code_file, keep.source = FALSE)
  last_val <- result_obj$value

  is_numeric <- !is.null(last_val) && is.numeric(last_val)

  result <- list(
    valid = is_numeric,
    message = if (is_numeric) "Valid numeric result" else "No numeric result found"
  )

  if (is_numeric) {
    result$is_finite <- all(is.finite(last_val))
    result$range <- range(last_val, na.rm = TRUE)
    result$length <- length(last_val)
  }

  cat(toJSON(result, auto_unbox = TRUE))
}, error = function(e) {
  cat(toJSON(list(valid = FALSE, error = as.character(e$message)), auto_unbox = TRUE))
})
