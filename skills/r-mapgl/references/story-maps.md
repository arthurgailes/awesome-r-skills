# Building Story Maps with mapgl

Source: <https://walker-data.com/mapgl/articles/story-maps.html>

## Overview

Story maps are interactive pages where scrolling triggers map changes and reveals content. mapgl supports Mapbox, MapLibre, and Leaflet backends for story maps in Shiny.

## Three core functions

1. **`story_map(map_id, sections, ...)`** builds the UI framework; wrap in a Shiny layout (e.g., `fluidPage()`). Variants: `story_maplibre()`, `story_leaflet()`.
2. **`story_section(title, content, position = "left")`** constructs an individual section. `title` may be `NULL` / `""`. `content` accepts HTML tags, Shiny inputs, or outputs.
3. **`on_section(map_id, section_id, expr)`** runs `expr` in the server when a named section becomes active.

## Minimal example

```r
library(shiny)
library(mapgl)

ui <- fluidPage(
  story_map(
    map_id = "map",
    sections = list(
      "intro" = story_section("Introduction", "This is a story map."),
      "location" = story_section("Location", "Check out this interesting location.")
    )
  )
)

server <- function(input, output, session) {
  output$map <- renderMapboxgl({ mapboxgl(scrollZoom = FALSE) })
}

shinyApp(ui, server)
```

Without `on_section()` handlers, scrolling transitions panels but the map does not change.

## Moving the map on scroll

```r
server <- function(input, output, session) {
  output$map <- renderMapboxgl({ mapboxgl(scrollZoom = FALSE) })

  on_section("map", "intro", {
    mapboxgl_proxy("map") |>
      fly_to(center = c(0, 0), zoom = 0, pitch = 0, bearing = 0)
  })

  on_section("map", "location", {
    mapboxgl_proxy("map") |>
      fly_to(center = c(12.49257, 41.890233),
             zoom = 17.5, pitch = 49, bearing = 12.8)
  })
}
```

Provide an `on_section()` handler for every section, including the intro, otherwise scrolling back up will not reset the view. For transitions choose `fly_to()`, `ease_to()`, or `jump_to()`.

## Full example: real-estate story with data layers

```r
library(shiny); library(mapgl); library(mapboxapi)

property <- c(-97.71326, 30.402550)
isochrone <- mb_isochrone(property, profile = "driving", time = 20)

ui <- fluidPage(
  tags$link(href = "https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap", rel = "stylesheet"),
  story_map(
    map_id = "map",
    font_family = "Poppins",
    sections = list(
      "intro" = story_section(
        title = "MULTIFAMILY INVESTMENT OPPORTUNITY",
        content = list(p("New Class A Apartments in Austin, Texas"),
                       img(src = "apartment.png", width = "300px")),
        position = "center"
      ),
      "marker" = story_section(
        title = "PROPERTY LOCATION",
        content = list(p("The property will be located in the thriving Domain district of north Austin."))
      ),
      "isochrone" = story_section(
        title = "AUSTIN AT YOUR FINGERTIPS",
        content = list(p("The property is within a 20-minute drive of downtown Austin."))
      )
    )
  )
)

server <- function(input, output, session) {
  output$map <- renderMapboxgl({
    mapboxgl(scrollZoom = FALSE, center = c(-97.7301093, 30.288647), zoom = 12)
  })

  on_section("map", "intro", {
    mapboxgl_proxy("map") |>
      clear_markers() |>
      fly_to(center = c(-97.7301093, 30.288647), zoom = 12, pitch = 0, bearing = 0)
  })

  on_section("map", "marker", {
    mapboxgl_proxy("map") |>
      clear_layer("isochrone") |>
      add_markers(data = property, color = "#CC5500") |>
      fly_to(center = property, zoom = 16, pitch = 45, bearing = -90)
  })

  on_section("map", "isochrone", {
    mapboxgl_proxy("map") |>
      add_fill_layer(id = "isochrone", source = isochrone,
                     fill_color = "#CC5500", fill_opacity = 0.5) |>
      fit_bounds(isochrone, animate = TRUE, duration = 8000, pitch = 75)
  })
}

shinyApp(ui, server)
```

Notes: Google fonts load via `tags$link()`; `font_family` applies globally. `content` may include local images (from `www/`). All story transitions use the proxy object. Default `position` is `"left"` (also `"center"`, `"right"`).

## With Shiny inputs + outputs

```r
library(tidycensus); library(tidyverse); library(sf)

fl_age <- get_acs(geography = "tract", variables = "B01002_001",
                  state = "FL", year = 2023, geometry = TRUE) |>
  separate_wider_delim(NAME, delim = "; ",
                       names = c("tract", "county", "state")) |>
  st_sf()

ui <- fluidPage(
  story_maplibre(
    map_id = "map",
    sections = list(
      "intro" = story_section(
        "Median Age in Florida",
        content = list(
          selectInput("county", "Select a county",
                      choices = sort(unique(fl_age$county))),
          p("Scroll down to view the median age distribution.")
        )
      ),
      "county" = story_section(
        title = NULL,
        content = list(uiOutput("county_text"), plotOutput("county_plot"))
      )
    )
  )
)

server <- function(input, output, session) {
  sel_county <- reactive({ filter(fl_age, county == input$county) })

  output$map <- renderMaplibre({
    maplibre(carto_style("positron"), bounds = fl_age, scrollZoom = FALSE) |>
      add_fill_layer(
        id = "fl_tracts", source = fl_age,
        fill_color = interpolate(
          column = "estimate", values = c(20, 80),
          stops = c("lightblue", "darkblue"), na_color = "lightgrey"
        ),
        fill_opacity = 0.5
      ) |>
      add_legend("Median age in Florida",
                 values = c(20, 80),
                 colors = c("lightblue", "darkblue"),
                 position = "bottom-right")
  })

  output$county_text <- renderUI({ h2(toupper(input$county)) })
  output$county_plot <- renderPlot({
    ggplot(sel_county(), aes(x = estimate)) +
      geom_histogram(fill = "lightblue", color = "black", bins = 10) +
      theme_minimal() + labs(x = "Median Age", y = "")
  })

  on_section("map", "intro", {
    maplibre_proxy("map") |>
      set_filter("fl_tracts", NULL) |>
      fit_bounds(fl_age, animate = TRUE)
  })

  on_section("map", "county", {
    maplibre_proxy("map") |>
      set_filter("fl_tracts", filter = list("==", "county", input$county)) |>
      fit_bounds(sel_county(), animate = TRUE)
  })
}

shinyApp(ui, server)
```

Key pattern: prefer `set_filter()` over clearing and re-adding layers -- it mutates the existing layer in place and is much more efficient.

## Publishing

Story maps are Shiny apps: deploy to ShinyApps.io, Posit Connect, or your own Shiny server.
