# Identify Pilot Week

To assist in comparisons across and within pilots, it can be useful to
look at what is happening each week. This function sets the week based
on the event's timestamp. The default is to calculate the week from the
time elapsed from the starting date of the pilot but it can also be
calculated using Sunday as the start of each week.

## Usage

``` r
add_pilot_week(df, type = "elapsed")
```

## Arguments

- df:

  mixpanel dataframe

- type:

  week calculated by time "elapsed" (default) or "week floor"

## Value

a data frame with a new column for pilot week

## Examples

``` r
if (FALSE) { # \dontrun{
df <- add_pilot_week(df)
} # }
```
