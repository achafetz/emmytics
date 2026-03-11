# Flag Completion Status at Event, Session, and/or Applicant Level

Creates binary completion flag columns on a web analytics dataframe,
indicating whether an applicant completed the target event
(`ApplicantSharedIncomeSummary`) at the event, session, and/or applicant
level.

## Usage

``` r
flag_completed(df, type = c("event", "session", "applicant"))
```

## Arguments

- df:

  A dataframe containing web analytics data. Must include the following
  columns:

  `event`

  :   Character. The name of the tracked event.

  `pilot`

  :   Character or factor. The pilot group identifier, used as a
      grouping variable for session- and applicant-level flags.

  `cbv_flow_id`

  :   Character or numeric. A unique session identifier. Required when
      `"session"` is included in `type`.

  `distinct_id`

  :   Character or numeric. A unique applicant identifier. Required when
      `"applicant"` is included in `type`.

- type:

  Character vector specifying which completion flags to generate. One or
  more of:

  `"event"`

  :   Adds `completed_event`: `TRUE` if the row's event is
      `ApplicantSharedIncomeSummary`, `FALSE` otherwise.

  `"session"`

  :   Adds `completed_session`: `TRUE` if any event within the same
      `pilot` + `cbv_flow_id` session is a completion event.

  `"applicant"`

  :   Adds `completed_applicant`: `TRUE` if any event across all
      sessions for the same `pilot` + `distinct_id` applicant is a
      completion event.

  Defaults to `c("event", "session", "applicant")` (all three).

## Value

A dataframe with the same rows as `df`, with one or more of the
following columns appended depending on `type`:

- `completed_event`:

  Logical. Row-level completion flag. Included only if `"event"` is in
  `type`.

- `completed_session`:

  Logical. Session-level completion flag. Included only if `"session"`
  is in `type`.

- `completed_applicant`:

  Logical. Applicant-level completion flag. Included only if
  `"applicant"` is in `type`.

## Details

The target completion event is defined internally as
`"ApplicantSharedIncomeSummary"`. A row-level `completed_event` flag is
first created, then session- and applicant-level flags are derived by
applying [`any()`](https://rdrr.io/r/base/any.html) within each group.
[`any()`](https://rdrr.io/r/base/any.html) returns `TRUE` if at least
one value in the group is `TRUE`, making the aggregation logic explicit
and self-documenting.

If `"event"` is not included in `type`, the intermediate
`completed_event` column is dropped from the returned dataframe.

Grouping configurations for `"session"` and `"applicant"` are defined
internally and applied functionally via
[`purrr::reduce()`](https://purrr.tidyverse.org/reference/reduce.html),
making it straightforward to extend the function with additional
grouping levels in the future.

## Examples

``` r
if (FALSE) { # \dontrun{
# Add all three flags (default)
df_flagged <- flag_completed(df)

# Add only the applicant-level flag
df_flagged <- flag_completed(df, type = "applicant")

# Add session and applicant flags, but not the raw event-level flag
df_flagged <- flag_completed(df, type = c("session", "applicant"))
} # }
```
