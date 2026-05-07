# Mixpanel Events and Properties

This dataset provides the full set of events and the specific properties
that are are captured in Mixpanel.

## Usage

``` r
event_properties
```

## Format

a data frame with 1,894 rows and 4 columns

## Details

The event are particularly useful to know when running an API call. It
is also useful to know which properties are associated with the event,
eg "ApplicantClickedCBVInvitationLink" has "seconds_since_invitation"
property. The property information can be extracted during the read in
using
[`read_mixpanel`](https://aaron-chafetz.com/emmytics/reference/read_mixpanel.md)
or directly using
[`extract_properties`](https://aaron-chafetz.com/emmytics/reference/extract_properties.md).

## See also

[`read_mixpanel`](https://aaron-chafetz.com/emmytics/reference/read_mixpanel.md),
[`extract_properties`](https://aaron-chafetz.com/emmytics/reference/extract_properties.md)
