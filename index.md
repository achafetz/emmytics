# emmytics

Provides utilities for fetching, cleaning, and analyzing web analytics
data from platforms like Mixpanel, with potential support for Adobe
Analytics and Google Analytics. Designed for the Eligibility Made Easy
(EMMY) project

## Installation

You can install the development version of emmytics from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("achafetz/emmytics")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(emmytics)

#setup .env.local file (first time) for API keys provided by project engineers
setup_env_file()

#API params
start <- "2025-11-16"
end <- "2025-12-19"
agency <- "la_ldh"

#run API for LA pilot Nov 2025 data
df_nov <- get_mixpanel_data(from_date = start, 
                            to_date = end, 
                            client_agency = agency)

#re-open stored data (in a future session)
df_again <- get_mixpanel_data(from_date = start, 
                              to_date = end, 
                              client_agency = agency)
```
