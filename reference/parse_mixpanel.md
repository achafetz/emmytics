# Parse Raw Mixpanel Data to DataFrame

Converts newline-delimited JSON text from Mixpanel into a tidy tibble.

## Usage

``` r
parse_mixpanel(raw_text)
```

## Arguments

- raw_text:

  Character string containing newline-delimited JSON

## Value

A tibble with event and properties columns

## See also

Other api:
[`cache_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/cache_mixpanel.md),
[`deduplicate_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/deduplicate_mixpanel.md),
[`fetch_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/fetch_mixpanel.md),
[`get_mixpanel_data()`](https://aaron-chafetz.com/emmytics/reference/get_mixpanel_data.md),
[`load_cached_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/load_cached_mixpanel.md),
[`standardize_properties()`](https://aaron-chafetz.com/emmytics/reference/standardize_properties.md)

## Examples

``` r
if (FALSE) { # \dontrun{
df <- parse_mixpanel_data(raw_text)
} # }
```
