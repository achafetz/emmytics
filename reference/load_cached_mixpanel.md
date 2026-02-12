# Load Cached Mixpanel Data

Loads previously cached Mixpanel data from either JSON format.

## Usage

``` r
load_cached_mixpanel(file_path)
```

## Arguments

- file_path:

  File path of the cached file

## Value

A tibble containing the cached Mixpanel event data

## See also

Other api:
[`cache_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/cache_mixpanel.md),
[`deduplicate_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/deduplicate_mixpanel.md),
[`fetch_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/fetch_mixpanel.md),
[`get_mixpanel_data()`](https://aaron-chafetz.com/emmytics/reference/get_mixpanel_data.md),
[`parse_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/parse_mixpanel.md),
[`standardize_properties()`](https://aaron-chafetz.com/emmytics/reference/standardize_properties.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Load from JSON
df <- load_cached_mixpanel("mixpanel_data_2025-11-16_to_2025-12-19.json")
} # }
```
