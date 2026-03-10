# Return Latest Pilot

This function returns the latest pilot in the dataset, relying on the
fact that pilot is a factor variable. Useful when there are multiple
pilot periods combined in the same dataframe.

## Usage

``` r
return_latest_pilot(df)
```

## Arguments

- df:

  a mixpanel dataframe

## Value

a character vector of the most recent pilot

## See also

[`pilot_pds`](https://aaron-chafetz.com/emmytics/reference/pilot_pds.md),
[`set_pilot`](https://aaron-chafetz.com/emmytics/reference/set_pilot.md)

Other pilot:
[`pilot_pds`](https://aaron-chafetz.com/emmytics/reference/pilot_pds.md),
[`set_pilot()`](https://aaron-chafetz.com/emmytics/reference/set_pilot.md)

## Examples

``` r
if (FALSE) { # \dontrun{
#identify paths for json data for each of the periods
mp_paths <- list.files("Data","json", full.names = TRUE)

#read in data
df_mp <- mp_path %>%
  set_names() %>%
  map(~ read_mixpanel(.x, drop_prop = FALSE)) %>%
  list_rbind(names_to = "source_path")

#store the latest pilot
latest <- return_latest_pilot(df_mp)
} # }
```
