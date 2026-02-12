# Get Mixpanel Data with Caching

Main function to fetch, parse, deduplicate, and cache Mixpanel data.

## Usage

``` r
get_mixpanel_data(
  from_date,
  to_date,
  client_agency,
  cache_dir = ".",
  force_reload = FALSE
)
```

## Arguments

- from_date:

  Start date in 'YYYY-MM-DD' format

- to_date:

  End date in 'YYYY-MM-DD' format

- client_agency:

  if provided, will filter down by specific agency (eg la_ldh)

- cache_dir:

  defaults to working directory

- force_reload:

  Logical. If TRUE, bypass cache and fetch fresh data

## Value

A tibble containing cleaned, deduplicated Mixpanel events

## See also

Other api:
[`cache_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/cache_mixpanel.md),
[`deduplicate_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/deduplicate_mixpanel.md),
[`fetch_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/fetch_mixpanel.md),
[`load_cached_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/load_cached_mixpanel.md),
[`parse_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/parse_mixpanel.md),
[`standardize_properties()`](https://aaron-chafetz.com/emmytics/reference/standardize_properties.md)

## Examples

``` r
if (FALSE) { # \dontrun{
df <- get_mixpanel_data("2025-11-16", "2025-12-19")
} # }
```
