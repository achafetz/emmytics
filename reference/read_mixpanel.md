# Read in Mixpanel data

This function importants and applies standardized munging a Mixpanel
dataset. It expects anNDJSON file input downloaded via
`get_mixpanel_data`. The function extracts key fields from properties,
distinct_id and cbv_flow_id, and allows the user to provide their own
fields they want to extract. It also identifies the specific pilot
periods for use in analysis.

## Usage

``` r
read_mixpanel(file, ..., applicant_only = TRUE, drop_prop = FALSE)
```

## Arguments

- file:

  filepath to ndjson, downloaded via `get_mixpanel_data`

- ...:

  \<[`dynamic-dots`](https://rlang.r-lib.org/reference/dyn-dots.html)\>
  Additional column specs to extract from the `properties` column. These
  should be provided as name-value pairs where the name is the new
  column name and the value is the expression to extract (e.g.,
  `user_id = properties$user_id`).

- applicant_only:

  keep only applicant data, dropping case worker and NA default = TRUE

- drop_prop:

  drop the nested properties column? default = FALSE

## Value

converts json to a formatted tibble

## Examples

``` r
if (FALSE) { # \dontrun{
# retrieve pilot data (LA Nov 2025)
get_mixpanel_data("2025-11-16", "2025-12-19", "la_ldh")

#path to json file downloaded
path <- "mixpanel_data_la_ldh_2025-11-16_to_2025-12-19.json"

#read in data with specific properties
df_la_nov <- read_mixpanel(path)
  
#read in data with specific properties
df_la_nov_extra <- read_mixpanel(path, 
        device_type = properties$device_type,
        origin = properties$origin)
  
} # }
```
