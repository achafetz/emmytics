# Get Mixpanel Data with Caching

Main function to fetch, parse, deduplicate, and cache Mixpanel data.

## Usage

``` r
get_mixpanel_data(
  from_date,
  to_date,
  client_agency,
  events,
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

  if provided, will filter down by specific agency. Run
  `unique(pilot_pds$client_agency)` to get the set of states/agencies.

- events:

  Character vector of event names to fetch. If NULL (default), all
  events are returned. E.g.
  `c("ApplicantViewedAgreement", "ApplicantSharedIncomeSummary")`

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

#pull all data over a specific time period
df_all <- get_mixpanel_data("2026-02-14", "2026-03-22")

#return just one agency's data over that period
df_la <- get_mixpanel_data("2026-02-14", "2026-03-22", 
                            client_agency = "la_ldh")
                            
#use stored information from pilot_pds
info <- pilot_pds %>%
  filter(state == "LA", pilot == "Feb 2026") %>% 
  select(start_date, end_date, client_agency) %>% 
  mutate(across(c(start_date, end_date), 
                \(x) as.character(x))) %>% 
    as.list()
  
df_la <- get_mixpanel_data(info$start_date, info$end_date,
                           client_agency = info$client_agency)
                           
#return only specific events
bounding_events <- c("ApplicantViewedAgreement", 
                     "ApplicantSharedIncomeSummary")
                     
df_la <- get_mixpanel_data(info$start_date, info$end_date,
                           client_agency = info$client_agency,
                           events = bounding_events 
                           )

} # }
```
