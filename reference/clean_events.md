# Clean Mixpanel events

Takes the Mixpanel event names and cleans them up, removing duplicative
"Applicant" prefix and adding a space between each work. For example,
"ApplicantAccessedSuccessPage" becomes "Accessed Success Page". This is
useful when presenting out the data.

## Usage

``` r
clean_events(df)
```

## Arguments

- df:

  data frame from Mixpanel with even names

## Value

dataframe with a new column for cleaned names

## Examples

``` r
if (FALSE) { # \dontrun{
df_viz <- df_subset %>% clean_events()
} # }
```
