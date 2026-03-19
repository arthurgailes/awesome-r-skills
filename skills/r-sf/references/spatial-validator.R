# Spatial Geometry Validation Patterns for SF Package

#' Validate SF Object Structure
#'
#' @param x An sf object to validate
#' @return List with 'valid' (logical) and 'messages' (character vector)
validate_sf_object <- function(x) {
  messages <- character(0)

  # Check if it's an sf object
  if (!inherits(x, "sf")) {
    return(list(valid = FALSE, messages = "Object is not an sf object"))
  }

  # Check for geometry column
  geom_col <- attr(x, "sf_column")
  if (is.null(geom_col) || !geom_col %in% names(x)) {
    messages <- c(messages, "Missing or invalid geometry column")
  }

  # Check CRS
  crs <- sf::st_crs(x)
  if (is.na(crs)) {
    messages <- c(messages, "Warning: CRS is not set")
  }

  # Check geometry validity
  invalid_geoms <- !sf::st_is_valid(x)
  if (any(invalid_geoms)) {
    messages <- c(messages,
                  sprintf("Found %d invalid geometries (rows: %s)",
                          sum(invalid_geoms),
                          paste(which(invalid_geoms)[1:min(5, sum(invalid_geoms))], collapse = ", ")))
  }

  # Check for empty geometries
  empty_geoms <- sf::st_is_empty(x)
  if (any(empty_geoms)) {
    messages <- c(messages,
                  sprintf("Found %d empty geometries", sum(empty_geoms)))
  }

  valid <- length(messages) == 0 || all(grepl("^Warning:", messages))

  list(valid = valid, messages = messages)
}

#' Validate CRS Compatibility
#'
#' @param x,y SF objects to check for CRS compatibility
#' @return List with 'compatible' (logical) and 'message' (character)
validate_crs_compatibility <- function(x, y) {
  crs_x <- sf::st_crs(x)
  crs_y <- sf::st_crs(y)

  if (is.na(crs_x) || is.na(crs_y)) {
    return(list(
      compatible = FALSE,
      message = "One or both objects have undefined CRS"
    ))
  }

  if (crs_x != crs_y) {
    return(list(
      compatible = FALSE,
      message = sprintf("CRS mismatch: x uses %s, y uses %s. Use st_transform() to align.",
                       crs_x$input, crs_y$input)
    ))
  }

  list(compatible = TRUE, message = "CRS compatible")
}

#' Repair Invalid Geometries
#'
#' @param x An sf object with potentially invalid geometries
#' @param verbose Print repair messages
#' @return SF object with repaired geometries
repair_geometries <- function(x, verbose = TRUE) {
  invalid <- !sf::st_is_valid(x)

  if (!any(invalid)) {
    if (verbose) message("All geometries are valid. No repairs needed.")
    return(x)
  }

  if (verbose) {
    message(sprintf("Repairing %d invalid geometries...", sum(invalid)))
  }

  # Make valid
  x_repaired <- x
  x_repaired[invalid, attr(x, "sf_column")] <- sf::st_make_valid(x[invalid, ])

  # Check if repair was successful
  still_invalid <- !sf::st_is_valid(x_repaired)
  if (any(still_invalid)) {
    warning(sprintf("%d geometries could not be repaired", sum(still_invalid)))
  } else if (verbose) {
    message("All geometries successfully repaired.")
  }

  x_repaired
}

#' Validate Spatial Operation Input
#'
#' @param x,y SF objects for spatial operation
#' @param operation Name of operation (for error messages)
#' @return List with 'ready' (logical) and 'issues' (character vector)
validate_spatial_operation <- function(x, y = NULL, operation = "spatial operation") {
  issues <- character(0)

  # Validate x
  x_check <- validate_sf_object(x)
  if (!x_check$valid) {
    issues <- c(issues, paste("x:", x_check$messages))
  }

  # Validate y if provided
  if (!is.null(y)) {
    y_check <- validate_sf_object(y)
    if (!y_check$valid) {
      issues <- c(issues, paste("y:", y_check$messages))
    }

    # Check CRS compatibility
    crs_check <- validate_crs_compatibility(x, y)
    if (!crs_check$compatible) {
      issues <- c(issues, crs_check$message)
    }
  }

  ready <- length(issues) == 0

  if (!ready) {
    message(sprintf("Issues found before %s:", operation))
    message(paste("  -", issues, collapse = "\n"))
  }

  list(ready = ready, issues = issues)
}

#' Safe Spatial Join with Validation
#'
#' @param x,y SF objects to join
#' @param join Spatial predicate function
#' @param repair_geometries Attempt to repair invalid geometries
#' @param ... Additional arguments passed to st_join
#' @return Joined sf object
safe_st_join <- function(x, y, join = sf::st_intersects,
                         repair_geometries = TRUE, ...) {

  # Validate inputs
  validation <- validate_spatial_operation(x, y, "spatial join")

  if (!validation$ready) {
    if (repair_geometries) {
      message("Attempting to repair geometries...")
      x <- repair_geometries(x, verbose = TRUE)
      y <- repair_geometries(y, verbose = TRUE)

      # Re-check CRS after repair
      crs_check <- validate_crs_compatibility(x, y)
      if (!crs_check$compatible) {
        stop(crs_check$message)
      }
    } else {
      stop("Input validation failed. Set repair_geometries = TRUE to attempt fixes.")
    }
  }

  # Perform join
  sf::st_join(x, y, join = join, ...)
}

#' Check for Common CRS Issues
#'
#' @param x An sf object
#' @return List with warnings and suggestions
check_crs_issues <- function(x) {
  crs <- sf::st_crs(x)
  issues <- list()

  if (is.na(crs)) {
    issues$missing_crs <- "CRS is not set. Assign with st_set_crs() or st_transform()."
    return(issues)
  }

  # Check for common geographic CRS
  if (crs$IsGeographic) {
    bbox <- sf::st_bbox(x)
    if (abs(bbox$xmax - bbox$xmin) > 180 || abs(bbox$ymax - bbox$ymin) > 90) {
      issues$geographic_bounds <- paste(
        "Object uses geographic CRS but coordinates exceed world bounds.",
        "Check if CRS was set incorrectly instead of transformed."
      )
    }

    # Warn about area/distance calculations
    issues$geographic_measurements <- paste(
      "Geographic CRS detected. Area/distance calculations will use",
      "spherical geometry (s2). Consider transforming to projected CRS",
      "for planar calculations."
    )
  }

  # Check for old-style PROJ4 strings
  if (!is.null(crs$proj4string) && is.na(crs$input)) {
    issues$deprecated_proj4 <- paste(
      "Object uses deprecated PROJ4 string.",
      "Consider setting CRS with EPSG code or WKT2."
    )
  }

  if (length(issues) == 0) {
    issues$status <- "No CRS issues detected."
  }

  issues
}
