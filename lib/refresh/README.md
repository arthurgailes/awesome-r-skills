# Skill refresh extractor

Pre-processes upstream R package metadata so the monthly refresh workflow's
Claude step reads small pre-digested input files instead of fetching raw HTML.

## Files

- `sources.yml` -- 11 entries (pkg, cran URL, pkgdown URL). Edit when a
  package's pkgdown site moves or a 12th package is added.
- `extract.R` -- reads `sources.yml`, fetches each CRAN page (for the version)
  and pkgdown reference index (for the function list), writes
  `inputs/{pkg}.txt`. On any fetch or parse failure that pkg's file gets an
  `error: ...` line; other packages still process.
- `inputs/` -- generated each run, gitignored. Not committed.

## Run locally

```bash
Rscript lib/refresh/extract.R
```

Required R packages: `rvest`, `yaml`, `xml2`. All on CRAN.

## When to edit

- A pkgdown URL 404s in the next monthly run -- update that entry's `pkgdown`
  field. The CRAN page's URL field is the canonical pointer.
- A 12th package is added to `skills/r-{pkg}/` -- add an entry.
- A package no longer publishes pkgdown -- remove the entry; the workflow's
  Claude step will note "no input file" and skip.
