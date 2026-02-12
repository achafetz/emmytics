# Follow applicant through their session

This function prints out a visual table of all event during an
applicant's session(s).

## Usage

``` r
follow_applicant(df, applicant, pilot_pd)
```

## Arguments

- df:

  Mixpanel dataframe

- applicant:

  an applicant's distinct_id

- pilot_pd:

  can limit this to a particular pilot, eg "Nov 2025"

## Value

a gt object

## See also

[`munge_journey`](https://aaron-chafetz.com/emmytics/reference/munge_journey.md)
for how data are munged for
[`plot_journey`](https://aaron-chafetz.com/emmytics/reference/plot_journey.md)
which visualizing this data

Other app_journey:
[`munge_journey()`](https://aaron-chafetz.com/emmytics/reference/munge_journey.md),
[`plot_journey()`](https://aaron-chafetz.com/emmytics/reference/plot_journey.md)

## Examples

``` r
if (FALSE) { # \dontrun{
df_mp <- read_parquet(mp_path)

df_mp %>%
  follow_applicant("applicant-123456")
} # }
```
