#!/usr/bin/env Rscript

# Reads lib/refresh/sources.yml and writes lib/refresh/inputs/{pkg}.txt for
# each entry. Each output file contains the package version and a sorted list
# of function/topic names from the pkgdown reference index. On any fetch or
# parse failure the file gets an "error: ..." line instead -- the workflow's
# Claude step surfaces those in the PR.

suppressPackageStartupMessages({
  library(rvest)
  library(yaml)
})

here <- function(...) file.path("lib", "refresh", ...)

cran_version <- function(url) {
  doc <- read_html(url)
  tds <- doc |> html_elements("td")
  labels <- html_text(tds)
  idx <- which(labels == "Version:")
  if (length(idx) == 0) stop("Version: cell not found on CRAN page")
  trimws(html_text(tds[idx[1] + 1]))
}

pkgdown_functions <- function(url) {
  doc <- read_html(url)
  fns <- doc |> html_elements("dl dt code a") |> html_text()
  fns <- trimws(fns)
  fns <- fns[nzchar(fns)]
  fns <- unique(fns)
  if (length(fns) == 0) stop("no function entries found at ", url)
  sort(fns)
}

write_input <- function(pkg, version, fns) {
  lines <- c(
    paste0("pkg: ", pkg),
    paste0("version: ", version),
    "functions:",
    paste0("  - ", fns)
  )
  writeLines(lines, here("inputs", paste0(pkg, ".txt")))
}

write_error <- function(pkg, msg) {
  writeLines(c(paste0("pkg: ", pkg), paste0("error: ", msg)),
             here("inputs", paste0(pkg, ".txt")))
}

main <- function() {
  sources <- yaml.load_file(here("sources.yml"))
  dir.create(here("inputs"), showWarnings = FALSE, recursive = TRUE)
  ok <- 0L; err <- 0L
  for (entry in sources) {
    pkg <- entry$pkg
    cat("[extract]", pkg, "... ")
    result <- tryCatch({
      version <- cran_version(entry$cran)
      fns <- pkgdown_functions(entry$pkgdown)
      write_input(pkg, version, fns)
      cat("ok (v", version, ", ", length(fns), " functions)\n", sep = "")
      "ok"
    }, error = function(e) {
      msg <- conditionMessage(e)
      write_error(pkg, msg)
      cat("ERROR: ", msg, "\n", sep = "")
      "err"
    })
    if (result == "ok") ok <- ok + 1L else err <- err + 1L
  }
  cat("\n[extract] done: ", ok, " ok, ", err, " error\n", sep = "")
}

main()
