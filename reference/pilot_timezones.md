# EMMY Pilot State Timezones

Mixpanel records event in UTC. This dataset provies a mapping between
the states and their timzones to convert from UTC to local time. Uses
IANA timezone strings from
[`OlsonNames()`](https://rdrr.io/r/base/timezones.html)

## Usage

``` r
pilot_timezones
```

## Format

a data frame with 4 rows and 2 columns
