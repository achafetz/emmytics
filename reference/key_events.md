# Key Events in Applicant Journey

A character vector containing the names of key events tracked during the
applicant journey process. These events represent important milestones
and actions taken by applicants as they progress through the application
workflow. They are primarily used for analytics to determine whether an
applicant reached each of they key stages.

## Usage

``` r
key_events
```

## Format

A character vector with 7 event names:

- ApplicantViewedAgreement:

  Applicant viewed the agreement document

- ApplicantAgreed:

  Applicant accepted the agreement terms

- ApplicantSelectedEmployerOrPlatformItem:

  Applicant selected an employer or platform item

- ApplicantAttemptedLogin:

  Applicant attempted to log in to the system

- ApplicantSucceededWithLogin:

  Applicant successfully logged in

- ApplicantViewedPaymentDetails:

  Applicant viewed payment details

- ApplicantSharedIncomeSummary:

  Applicant shared their income summary

## See also

[`key_events_clean`](https://aaron-chafetz.com/emmytics/reference/key_events_clean.md),
[`key_events_clean_br`](https://aaron-chafetz.com/emmytics/reference/key_events_clean_br.md)

Other key_events:
[`key_events_clean`](https://aaron-chafetz.com/emmytics/reference/key_events_clean.md),
[`key_events_clean_br`](https://aaron-chafetz.com/emmytics/reference/key_events_clean_br.md)

## Examples

``` r
# View all key events
key_events
#> [1] "ApplicantViewedAgreement"               
#> [2] "ApplicantAgreed"                        
#> [3] "ApplicantSelectedEmployerOrPlatformItem"
#> [4] "ApplicantAttemptedLogin"                
#> [5] "ApplicantSucceededWithLogin"            
#> [6] "ApplicantViewedPaymentDetails"          
#> [7] "ApplicantSharedIncomeSummary"           

# Check if an event is a key event
"ApplicantAgreed" %in% key_events
#> [1] TRUE

# Filter a dataset to only key events
if (FALSE) { # \dontrun{
 event_data %>%
   filter(event %in% key_events)
} # }
```
