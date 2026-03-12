#!/usr/bin/env Rscript
# Basic spatial validation - checks if code produces sf object
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Usage: Rscript spatial-validator.R <code_file.R>")
}

code_file <- args[1]

library(jsonlite)
library(sf)

tryCatch({
  result_obj <- source(code_file, keep.source = FALSE)
  last_val <- result_obj$value

  is_sf <- !is.null(last_val) && inherits(last_val, "sf")

  result <- list(
    valid = is_sf,
    message = if (is_sf) "Valid sf object" else "No sf object found"
  )

  if (is_sf) {
    result$crs <- st_crs(last_val)$input
    result$geometry_type <- as.character(unique(st_geometry_type(last_val)))
    result$n_features <- nrow(last_val)
  }

  cat(toJSON(result, auto_unbox = TRUE))
}, error = function(e) {
  cat(toJSON(list(valid = FALSE, error = as.character(e$message)), auto_unbox = TRUE))
})
