# Performance Tips

1. **File format matters:** GeoParquet > GeoPackage > Shapefile for large data
2. **Filter early:** Use SQL to reduce data before tiling
3. **Optimize zoom ranges:** Don't tile beyond necessary detail level
4. **Multi-layer strategy:** Separate geometries by scale (states at low zoom, blocks at high zoom)
5. **Streaming flag:** Use `streaming = "always"` for point datasets >10M features

## Installation

```r
# Via r-universe (recommended)
install.packages("freestiler",
  repos = c("https://walkerke.r-universe.dev",
            "https://cloud.r-project.org"))

# Via GitHub
devtools::install_github("walkerke/freestiler")
```

## Additional Resources

- **PMTiles spec:** https://github.com/protomaps/PMTiles
- **Package documentation:** https://walker-data.com/freestiler/
- **GitHub repository:** https://github.com/walkerke/freestiler/
