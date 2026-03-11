#' Follow applicant through their session
#' 
#' This function prints out a visual table of all event during an applicant's
#' session(s). 
#'
#' @param df Mixpanel dataframe
#' @param applicant an applicant's distinct_id
#' @param pilot_pd can limit this to a particular pilot, eg "Nov 2025"
#'
#' @returns a gt object 
#' @export
#'
#' @family app_journey
#' @seealso \code{\link{munge_journey}} for how data are munged for 
#'   \code{\link{plot_journey}} which visualizing this data 
#'   
#' @examples
#' \dontrun{
#' df_mp <- read_parquet(mp_path)
#' 
#' df_mp %>%
#'   follow_applicant("applicant-123456")
#' }

follow_applicant <- function(df, applicant, pilot_pd){
  
  if(missing(applicant) || is.null(applicant))
    cli::cli_abort("No {.code distinct_id} provided in {.code applicant}")
  
  if(missing(pilot_pd) || is.null(pilot_pd))
    pilot_pd <- unique(df$pilot)
  
  #subset data to particular applicant & remove initial access point
  df_viz <- df %>% 
    dplyr::filter(
      distinct_id == applicant,
      pilot %in% pilot_pd,
      !event %in% c("ApplicantClickedCBVInvitationLink", "ApplicantClickedGenericLink")
    )
  
  #extract employer and query if not found
  if (!"employer_name" %in% names(df_viz))
    df_viz <- extract_properties(df_viz, employer_name = properties$employment_employer_name)
  
  #extract employer and query if not found
  if (!"query" %in% names(df_viz))
    df_viz <- extract_properties(df_viz, query = properties$query)
  
  #join query + employer
  df_viz <- df_viz %>% 
    dplyr::mutate(query_empl = dplyr::case_when(!is.na(query) ~ query,
                                         !is.na(employer_name) ~ employer_name))
  
  #add date to flow and limit columns of interest
  df_viz <- df_viz %>% 
    dplyr::group_by(cbv_flow_id) %>% 
    dplyr::mutate(flow_date = stringr::str_glue(
      "CBV Flow: {cbv_flow_id} [{lubridate::as_datetime(min(timestamp))}]")) %>% 
    dplyr::ungroup() %>% 
    dplyr::distinct(flow_date, timestamp, event, employer_name, query_empl)
  
  #encode important events
  df_viz <- df_viz %>% 
    dplyr::mutate(
      employer_name = ifelse(event == "ApplicantFinishedSync" & is.na(employer_name),
                             "[missing!]",
                             employer_name),
      status = dplyr::case_when(
        stringr::str_detect(event, "Failed") ~ "exclamation-triangle",
        stringr::str_detect(event, "Error") ~ "xmark",
        employer_name == "[missing!]" ~ "exclamation-triangle",
        event == "ApplicantViewedAgreement" ~ "circle-play",
        event == "ApplicantAgreed" ~ "circle-right",
        event == "ApplicantSelectedEmployerOrPlatformItem" ~ "square-check",
        event == "ApplicantAttemptedLogin" ~ "door-closed",
        event == "ApplicantSucceededWithLogin" ~ "handshake",
        event == "ApplicantViewedPaymentDetails" ~ "magnifying-glass",
        event == "ApplicantAccessedMissingResultsPage" ~ "exclamation-triangle",
        event == "ApplicantSharedIncomeSummary" ~ "flag-checkered",
        event == "ApplicantSearchedForEmployer" ~ "binoculars",
        stringr::str_detect(event, "Help") ~ "circle-question"
      )
    ) %>%
    clean_events() %>% 
    dplyr::select(-c(event, employer_name)) %>% 
    dplyr::relocate(status, .after = timestamp)
  
  #gt table
  df_viz %>%
    gt::gt(groupname_col = "flow_date") %>%
    gt::fmt_datetime(columns = c(timestamp),
                     format = "%I:%M:%S %p") %>%
    gt::sub_missing(missing_text = "") %>%
    gt::fmt_icon(columns = c(status),
                 fill_color = list("exclamation-triangle" = dsac_gold,
                                   "xmark" = dsac_light_cranberry,
                                   "flag-checkered" = dsac_light_navy,
                                   "binoculars" = "#909090",
                                   "circle-play" = "#909090",
                                   "circle-right" = "#909090",
                                   "square-check" = "#909090",
                                   "circle-question" = "#909090",
                                   "door-closed" = "#909090",
                                   "handshake" = "#909090",
                                   "magnifying-glass" = "#909090"),
                 height = "1.5em") %>%
    gt::cols_align(columns = c(status), align = "center") %>%
    gt::tab_options(column_labels.hidden = TRUE) %>%
    gt::tab_style(style = list(gt::cell_fill(color = "#E5E5E5"),
                               gt::cell_text(weight = "bold")),
                  locations = gt::cells_row_groups())
  
  
}