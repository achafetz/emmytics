# Munge data for journey visualization plot

This function provides the initial munging steps to process the data in
a way that can then be handled by
[`plot_journey`](https://aaron-chafetz.com/emmytics/reference/plot_journey.md)

## Usage

``` r
munge_journey(df, applicant, pilot_pd)
```

## Arguments

- df:

  Mixpanel dataframe

- applicant:

  an applicant's distinct_id

- pilot_pd:

  can limit this to a particular pilot, eg "Nov 2025"

## Value

processed dataframe for use with
[`plot_journey`](https://aaron-chafetz.com/emmytics/reference/plot_journey.md)

## See also

[`plot_journey`](https://aaron-chafetz.com/emmytics/reference/plot_journey.md)
for visualizing this data or
[`follow_applicant`](https://aaron-chafetz.com/emmytics/reference/follow_applicant.md)
for a tabular view of all events

Other app_journey:
[`follow_applicant()`](https://aaron-chafetz.com/emmytics/reference/follow_applicant.md),
[`plot_journey()`](https://aaron-chafetz.com/emmytics/reference/plot_journey.md)

## Examples

``` r
if (FALSE) { # \dontrun{
df_mp <- read_parquet(mp_path)

df_mp %>%
  munge_journey("applicant-123456") %>% 
  plot_journey(export = "../Images/")
} # }
```
