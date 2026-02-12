# Fetch Data from Mixpanel API

Retrieves raw event data from the Mixpanel Export API for a specified
date range.

## Usage

``` r
fetch_mixpanel(params, env_path)
```

## Arguments

- params:

  a named list containing API parameters (from_date, to_date,
  client_agency, etc.)

- env_path:

  path to the .env file containing credentials. Default is ".env.local"

## Value

A character string containing newline-delimited JSON, or NULL if the
request fails

## See also

Other api:
[`cache_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/cache_mixpanel.md),
[`deduplicate_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/deduplicate_mixpanel.md),
[`get_mixpanel_data()`](https://aaron-chafetz.com/emmytics/reference/get_mixpanel_data.md),
[`load_cached_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/load_cached_mixpanel.md),
[`parse_mixpanel()`](https://aaron-chafetz.com/emmytics/reference/parse_mixpanel.md),
[`standardize_properties()`](https://aaron-chafetz.com/emmytics/reference/standardize_properties.md)

## Examples

``` r
if (FALSE) { # \dontrun{
params <- list(from_date = "2025-11-16", to_date = "2025-12-19")
raw_data <- fetch_mixpanel(params)
} # }
```
