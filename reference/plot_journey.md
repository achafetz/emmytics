# Create a journey visualization plot

Create a journey visualization plot

## Usage

``` r
plot_journey(df, export_fldr)
```

## Arguments

- df:

  a data frame munged by
  [`munge_journey`](https://aaron-chafetz.com/emmytics/reference/munge_journey.md)

- export_fldr:

  if specified, this is the folder path where the file will be exported
  to (default = missing, no export)

## Value

A ggplot object

## See also

[`munge_journey`](https://aaron-chafetz.com/emmytics/reference/munge_journey.md)
for how data are munged for viz or
[`follow_applicant`](https://aaron-chafetz.com/emmytics/reference/follow_applicant.md)
for a tabular view of all events

Other app_journey:
[`follow_applicant()`](https://aaron-chafetz.com/emmytics/reference/follow_applicant.md),
[`munge_journey()`](https://aaron-chafetz.com/emmytics/reference/munge_journey.md)

## Examples

``` r
if (FALSE) { # \dontrun{
df_mp <- read_parquet(mp_path)

df_mp %>%
  munge_journey("applicant-123456") %>%
  plot_journey(export = "../Images/")
} # }
```
