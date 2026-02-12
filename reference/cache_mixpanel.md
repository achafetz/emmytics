# Cache Mixpanel Data

Saves cleaned Mixpanel data to disk in NDJSON format and can be opened
with jsonlite::stream_in() or arrow::read_json_arrow().

## Usage

``` r
cache_mixpanel(df, file_path)
```

## Arguments

- df:

  A tibble containing cleaned Mixpanel event data

- file_path:

  file path for the cached file

## Value

exports file and returns formatted data frame

## See also

Other api:
[`deduplicate_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/deduplicate_mixpanel.md),
[`fetch_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/fetch_mixpanel.md),
[`get_mixpanel_data()`](https://aaron-chafetz.com/emmytics/reference/get_mixpanel_data.md),
[`load_cached_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/load_cached_mixpanel.md),
[`parse_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/parse_mixpanel.md),
[`standardize_properties()`](https://aaron-chafetz.com/emmytics/reference/standardize_properties.md)

## Examples

``` r
if (FALSE) { # \dontrun{
#' # Save as JSON (default)
cache_mixpanel(df, "mixpanel_data_2025-11-16_to_2025-12-19.json")
} # }
```
