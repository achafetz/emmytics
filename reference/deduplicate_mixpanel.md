# Deduplicate Mixpanel Events

Removes duplicate events based on \$insert_id, keeping the most recent
occurrence.

## Usage

``` r
deduplicate_mixpanel(df)
```

## Arguments

- df:

  A tibble containing Mixpanel event data with nested properties

## Value

A deduplicated tibble

## See also

Other api:
[`cache_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/cache_mixpanel.md),
[`fetch_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/fetch_mixpanel.md),
[`get_mixpanel_data()`](https://aaron-chafetz.com/emmytics/reference/get_mixpanel_data.md),
[`load_cached_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/load_cached_mixpanel.md),
[`parse_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/parse_mixpanel.md),
[`standardize_properties()`](https://aaron-chafetz.com/emmytics/reference/standardize_properties.md)

## Examples

``` r
if (FALSE) { # \dontrun{
clean_df <- deduplicate_mixpanel_events(df)
} # }
```
