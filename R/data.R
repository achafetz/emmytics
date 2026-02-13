#' EMMY State Pilot Periods
#'
#' The following dataset notes the pilot periods run in various states. 
#'
#' @format a data frame with 5 rows and 5 columns
#' @family pilot
#' @seealso \code{\link{set_pilot}}, \code{\link{return_latest_pilot}}
#' \describe{
#'   \item{name}{Name of the pilot}
#'   \item{state}{Two letter state abbreviation of the pilot state}
#'   \item{client_agency}{The state agency code used in Mixpanel}
#'   \item{start_date, end_date}{start and end period of the pilot, dates}
#'   \item{pilot}{month and year of pilot}
#' }
"pilot_pds"


#' Key Events in Applicant Journey
#'
#' A character vector containing the names of key events tracked during the
#' applicant journey process. These events represent important milestones and
#' actions taken by applicants as they progress through the application 
#' workflow. They are primarily used for analytics to determine whether an 
#' applicant reached each of they key stages.
#' 
#' @format A character vector with 7 event names:
#' \describe{
#'   \item{ApplicantViewedAgreement}{Applicant viewed the agreement document}
#'   \item{ApplicantAgreed}{Applicant accepted the agreement terms}
#'   \item{ApplicantSelectedEmployerOrPlatformItem}{Applicant selected an employer or platform item}
#'   \item{ApplicantAttemptedLogin}{Applicant attempted to log in to the system}
#'   \item{ApplicantSucceededWithLogin}{Applicant successfully logged in}
#'   \item{ApplicantViewedPaymentDetails}{Applicant viewed payment details}
#'   \item{ApplicantSharedIncomeSummary}{Applicant shared their income summary}
#' }
#' 
#' @family key_events
#' @seealso \code{\link{key_events_clean}}, \code{\link{key_events_clean_br}}
#' 
#' @examples
#' # View all key events
#' key_events
#' 
#' # Check if an event is a key event
#' "ApplicantAgreed" %in% key_events
#' 
#' # Filter a dataset to only key events
#' \dontrun{
#'  event_data %>%
#'    filter(event %in% key_events)
#' }
"key_events"

#' Key Events in Applicant Journey (Cleaned for Display)
#'
#' A cleaned version of \code{\link{key_events}} with spaces added for improved
#' readability in visualizations and reports. Event names are transformed from
#' camelCase to human-readable format.
#'
#' @format A character vector with 7 cleaned event names with spaces added
#' between words for display purposes.
#'
#' @details
#' This vector is derived from \code{\link{key_events}} using the
#' \code{clean_events()} function to add spaces between words. Use this version
#' when creating visualizations or reports where readability is important.
#'
#' @family key_events
#' @seealso \code{\link{key_events}} for the original event names,
#'   \code{\link{key_events_clean_br}} for the line break version
"key_events_clean"

#' Key Events in Applicant Journey (With Line Breaks)
#'
#' A version of \code{\link{key_events_clean}} with line breaks (\code{\\n})
#' replacing spaces for multi-line display in visualizations with limited
#' horizontal space.
#'
#' @format A character vector with 7 event names containing line breaks
#' (\code{\\n}) instead of spaces for vertical display.
#'
#' @details
#' This vector is derived from \code{\link{key_events_clean}} by replacing
#' spaces with line breaks. Use this version when creating visualizations with
#' limited horizontal space where vertical text wrapping is preferred.
#'
#' @family key_events
#' @seealso \code{\link{key_events}} for the original event names,
#'   \code{\link{key_events_clean}} for the space-separated version
"key_events_clean_br"

#' DSAC Color Palette
#'
#' A named vector of hex color codes for DSAC (Data Science and Analytics Center) branding.
#' This palette includes primary colors and their lighter/darker variants for use in
#' data visualizations and graphics.
#'
#' @format A named character vector with 10 colors:
#' \describe{
#'   \item{dsac_navy}{Primary navy blue (#103D68)}
#'   \item{dsac_teal}{Primary teal (#136A5D)}
#'   \item{dsac_cranberry}{Primary cranberry (#6A1344)}
#'   \item{dsac_gold}{Accent gold (#EFAC2F)}
#'   \item{dsac_light_navy}{Light navy variant (#63789D)}
#'   \item{dsac_pale_navy}{Pale navy variant (#C1C9D7)}
#'   \item{dsac_light_teal}{Light teal variant (#5A9088)}
#'   \item{dsac_pale_teal}{Pale teal variant (#D9E8E5)}
#'   \item{dsac_light_cranberry}{Light cranberry variant (#842F66)}
#'   \item{dsac_dark_navy}{Dark navy variant (#123054)}
#' }
#'
#' @examples
#' # View all colors
#' dsac_colors
#'
#' # Access a specific color from the vector
#' dsac_colors["dsac_navy"]
"dsac_colors"

#' DSAC Navy Color
#'
#' Primary navy blue color from the DSAC color palette.
#'
#' @format A character string containing the hex code: "#103D68"
#' @seealso \code{\link{dsac_colors}} for the complete color palette
"dsac_navy"

#' DSAC Teal Color
#'
#' Primary teal color from the DSAC color palette.
#'
#' @format A character string containing the hex code: "#136A5D"
#' @seealso \code{\link{dsac_colors}} for the complete color palette
"dsac_teal"

#' DSAC Cranberry Color
#'
#' Primary cranberry color from the DSAC color palette.
#'
#' @format A character string containing the hex code: "#6A1344"
#' @seealso \code{\link{dsac_colors}} for the complete color palette
"dsac_cranberry"

#' DSAC Gold Color
#'
#' Accent gold color from the DSAC color palette.
#'
#' @format A character string containing the hex code: "#EFAC2F"
#' @seealso \code{\link{dsac_colors}} for the complete color palette
"dsac_gold"

#' DSAC Light Navy Color
#'
#' Light navy variant from the DSAC color palette.
#'
#' @format A character string containing the hex code: "#63789D"
#' @seealso \code{\link{dsac_colors}} for the complete color palette
"dsac_light_navy"

#' DSAC Pale Navy Color
#'
#' Pale navy variant from the DSAC color palette.
#'
#' @format A character string containing the hex code: "#C1C9D7"
#' @seealso \code{\link{dsac_colors}} for the complete color palette
"dsac_pale_navy"

#' DSAC Light Teal Color
#'
#' Light teal variant from the DSAC color palette.
#'
#' @format A character string containing the hex code: "#5A9088"
#' @seealso \code{\link{dsac_colors}} for the complete color palette
"dsac_light_teal"

#' DSAC Pale Teal Color
#'
#' Pale teal variant from the DSAC color palette.
#'
#' @format A character string containing the hex code: "#D9E8E5"
#' @seealso \code{\link{dsac_colors}} for the complete color palette
"dsac_pale_teal"

#' DSAC Light Cranberry Color
#'
#' Light cranberry variant from the DSAC color palette.
#'
#' @format A character string containing the hex code: "#842F66"
#' @seealso \code{\link{dsac_colors}} for the complete color palette
"dsac_light_cranberry"

#' DSAC Dark Navy Color
#'
#' Dark navy variant from the DSAC color palette.
#'
#' @format A character string containing the hex code: "#123054"
#' @seealso \code{\link{dsac_colors}} for the complete color palette
"dsac_dark_navy"