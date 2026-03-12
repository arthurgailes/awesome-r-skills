#!/usr/bin/env Rscript
# Basic HTML validation - checks if HTML is well-formed
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Usage: Rscript html-validator.R <html_file.html>")
}

html_file <- args[1]

library(jsonlite)
library(xml2)

tryCatch({
  doc <- read_html(html_file)

  result <- list(
    valid = TRUE,
    has_body = length(xml_find_all(doc, "//body")) > 0,
    has_table = length(xml_find_all(doc, "//table")) > 0,
    has_style = length(xml_find_all(doc, "//style")) > 0,
    message = "Valid HTML document"
  )

  cat(toJSON(result, auto_unbox = TRUE))
}, error = function(e) {
  cat(toJSON(list(valid = FALSE, error = as.character(e$message)), auto_unbox = TRUE))
})
