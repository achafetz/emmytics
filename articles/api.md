# Mixpanel API

## Introduction

One of the primary purposes of the `emmytics` package is to access data
from Mixpanel. Once you have your credentials setup (see the [Local
Setup for Mixpanel API
Access](https://aaron-chafetz.com/emmytics/articles/env_setup.md)
vignette), you can use `get_mixpanel_data` to query the data.

## Query data

The first thing you’ll need to do is load `emmytics` for the API access
and `dplyr` for basic munging.

``` r
library(dplyr)
library(emmytics)
```

Web analytics data for a number of pilots are stored and accessible from
Mixpanel. To access the table of current pilot in Mixpanel and their
dates, you can run `pilot_pds`. You can then store one of the pilots
start and end dates to use in the api.

``` r
#see pilot dates
pilot_pds
#> # A tibble: 7 × 6
#>   name                     state client_agency start_date end_date   pilot   
#>   <chr>                    <chr> <chr>         <date>     <date>     <chr>   
#> 1 LA LWC May run           LA    la_ldh        2025-05-18 2025-06-30 May 2025
#> 2 AZ Constrained MAC Pilot AZ    az_des        2025-06-13 2025-08-13 Jun 2025
#> 3 AZ Expanded MAC Pilot    AZ    az_des        2025-08-14 2025-09-04 Aug 2025
#> 4 LA LWC August Run        LA    la_ldh        2025-08-17 2025-09-30 Aug 2025
#> 5 LA LWC November Run      LA    la_ldh        2025-11-16 2025-12-19 Nov 2025
#> 6 LA LWC February Run      LA    la_ldh        2026-02-14 2026-03-20 Feb 2026
#> 7 LA LWC March Run         LA    la_ldh        2026-03-22 2026-04-25 Mar 2026
```

If you were interested in pulling down the data from the Louisiana
November 2025, you could grab those dates from the `pilot_pds` table to
use in your API.

``` r
#use the dates from the LA 2025 November pilot
la_2025nov <- pilot_pds %>% 
  filter(state == "LA", pilot == "Nov 2025")

la_2025nov
#> # A tibble: 1 × 6
#>   name                state client_agency start_date end_date   pilot   
#>   <chr>               <chr> <chr>         <date>     <date>     <chr>   
#> 1 LA LWC November Run LA    la_ldh        2025-11-16 2025-12-19 Nov 2025
```

You can plug these dates into `get_mixpanel_data` to access and store
the Mixpanel data locally in your project’s `/Data` folder.

``` r
#run API & store locally
get_mixpanel_data(
    from_date = la_2025nov$start_date,
    to_date = la_2025nov$end_date,
    client_agency = la_2025nov$client_agency,
    cache_dir = "Data"
    )
```

Running this function will store the data a NDJSON
(`Data/mixpanel_data_la_ldh_2025-11-16_to_2025-11-22.json`) for use in
your analytics.
