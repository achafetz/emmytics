# Mixpanel Analysis and Viz

## Introduction

In addition to [accessing the Mixpanel
API](https://aaron-chafetz.com/emmytics/articles/api.md), `emmytics` has
a number of functions to help standardize analysis.

## Standard Analytic Question

To demonstrate some of the munging utility functions, let’s answer a
simple question that a state colleague is interested in - what does the
distribution of sync times look like for this pilot?

``` r

library(dplyr)
library(emmytics)
```

The first thing we will do is read in the NDJSON file from the pilot
that we [accessed through the API and stored
locally](https://aaron-chafetz.com/emmytics/articles/api.md).

``` r

path <- list.files("Data/", "json", full.names = TRUE)
df <- read_mixpanel(path)
```

The `read_mixpanel` is reading in the NDJSON file using `arrow` to
quickly reading in the data and converting it into a tibble for ease of
use. Along the way, it is also:

1.  converting the dates to actual date fields
2.  standardizing the `events` field by removing the provider and
    creating this as its down column (eg `ApplicantFinishedArgyleSync`
    and `ApplicantFinishedPinwheelSync` both become
    `ApplicantFinishedSync`)
3.  caseworker events are filtered out since the focus is on applicants
4.  page view events (`CbvPageView`) are dropped as they don’t have any
    useful properties
5.  the pilot information is added for ease of use across pilots,
    internally running `set_pilot`

From here we can subset our dataset down to just the syncing events
which will contain the information we are looking for on sync times.

``` r

df_syncs <- df |>
  filter(event == "ApplicantFinishedSync")
```

Not terribly useful here, but you can run, `clean_events` to add spacing
and remove the repetitive “Applicant” to all events. This function comes
in handy for plotting data. For this data, you would see
“ApplicantFinishedSync” become a more legible “Finished Sync”.

``` r

df_syncs <- df_syncs |>
  clean_events()

df_syncs %>% 
  distinct(event, event_clean)
```

The sync time information stored within the nested `properties` column.
We can extract it using another `emmytics` function,
`extact_properties`.

``` r


df_syncs <- df_syncs |>
    extract_properties(sync_duration_seconds = properties$sync_duration_seconds)
```

Another alternative to this would have been to do this during the data
import step and then drop the properties column all together
(`drop_prop = TRUE`).

``` r

df_alt <- read_mixpanel(path, 
                        sync_duration_seconds = properties$sync_duration_seconds,
                        drop_prop = TRUE)
```

Now that we have the data we want, we can report out the summary stats.

``` r

df_syncs |>
    summarise(
        n = n(),
        min = min(sync_duration_seconds, na.rm = TRUE),
        q25 = quantile(sync_duration_seconds, 0.25, na.rm = TRUE),
        median = median(sync_duration_seconds, na.rm = TRUE),
        mean = mean(sync_duration_seconds, na.rm = TRUE),
        q75 = quantile(sync_duration_seconds, 0.75, na.rm = TRUE),
        max = max(sync_duration_seconds, na.rm = TRUE),
        .groups = "drop"
    )
```

## Applicant tracking/journey visuals

Another standard review that might occur is tracking an applicant’s
journey of events. This can be done within the Mixpanel site itself, but
it is often useful to do this review while working on a local analytic
question. This function leverages `gt` with some Font Awesome icons to
better visualize this process.

You will need to identify a particular applicant to track, in this case
we will use `applicant-123456`. This function will give us a tabular
display of each of the events (with icons at key events) and their
associated times.

``` r

df %>%
  follow_applicant("applicant-123456")
```

There is another similar function used for creating more a graphical
display. Here you need to run two function to first munge data and then
plot the visual.

*You will need to have the Font Awesome 7 Free typeface installed to
visualize this. It is [free to
download](https://fontawesome.com/download) and can be easily installed
on your desktop.*

``` r

df %>% 
  munge_journey("applicant-123456") %>%
  plot_journey()
```
