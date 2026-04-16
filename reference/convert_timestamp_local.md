# Convert UTC Timestamps to State-Specific Local Timezones

Converts a UTC `timestamp` column in a dataframe to the appropriate
local timezone based on a two-letter state abbreviation column
(`pilot_state`). Uses a built-in IANA timezone lookup table that can be
extended as new states are added to the `pilot_timezone` dataset.

## Usage

``` r
convert_timestamp_local(df)
```

## Arguments

- df:

  A `data.frame` or `tibble` containing at minimum:

  `pilot_state`

  :   A character column of two-letter U.S. state abbreviations (e.g.,
      `"LA"`, `"AZ"`, `"NH"`).

  `timestamp`

  :   A `POSIXct` datetime column in UTC.

## Value

A `tibble` identical to `df` with the `timestamp` column converted to
each row's corresponding local timezone.

## Details

Timezone mappings use IANA timezone strings (e.g., `"America/Chicago"`).
To add support for additional states, append rows to the internal
`pilot_timezone` tribble. A full list of valid IANA timezone strings can
be retrieved in R via
[`OlsonNames()`](https://rdrr.io/r/base/timezones.html).

Note that Arizona (`"AZ"`) uses `"America/Phoenix"`, which does **not**
observe Daylight Saving Time (DST), unlike most of the Mountain Time
zone.

## Note

This function uses
[`lubridate::with_tz()`](https://lubridate.tidyverse.org/reference/with_tz.html)
to convert the instant in time to its local representation without
altering the underlying moment.
