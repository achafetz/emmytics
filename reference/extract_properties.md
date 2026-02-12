# Extract Properties from Nested Column

Extracts key columns from a nested `properties` column in a data frame
and creates new columns at the top level. The function always extracts a
core set of properties and allows for flexible addition of extra columns
through the ellipsis (`...`) parameter.

## Usage

``` r
extract_properties(df, ...)
```

## Arguments

- df:

  A data frame or tibble containing a nested `properties` column.

- ...:

  \<[`dynamic-dots`](https://rlang.r-lib.org/reference/dyn-dots.html)\>
  Additional column specifications to extract from the `properties`
  column. These should be provided as name-value pairs where the name is
  the new column name and the value is the expression to extract (e.g.,
  `user_id = properties$user_id`).

## Value

A data frame with the same structure as `df` but with additional columns
extracted from the `properties` nested column.

## Details

The function first extracts a predefined set of core columns from the
nested `properties` column. The `help_topic` column is conditionally set
to `help_section` if `help_section` is not NA, otherwise it retains the
value from `properties$topic`.

Additional columns can be specified using the `...` parameter, allowing
for flexible extraction of other properties without modifying the
function.

## Examples

``` r
if (FALSE) { # \dontrun{
# Basic usage with core columns only
df_processed <- extract_properties(df_import)

# With additional columns
df_processed <- extract_properties(
  df_import,
  user_id = properties$user_id,
  timestamp = properties$timestamp,
  session_duration = properties$session_duration
)
} # }

```
