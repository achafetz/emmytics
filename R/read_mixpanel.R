
read_mixpanel <- function(file, applicant_only = TRUE){
  
  #check format is json
  if(!grepl(".*json$", file))
      cli::cli_abort(
        c("Expected a json file",
          i = "file{?s} = {.file {file}}"))
  
  #read in one or more files
  df_import <- file %>% 
    purrr::map(arrow::read_json_arrow) %>% 
    purrr::list_rbind()
  
  #convert to date time
  df_import <- df_import %>% 
    dplyr::mutate(timestamp = lubridate::as_datetime(timestamp))
  
  # extract applicant and flow ids from the nested properties list
  df_import <- df_import %>%
    dplyr::mutate(
      distinct_id = properties$distinct_id,
      cbv_flow_id = properties$cbv_flow_id,
    )
  
  #applicant only
  if(applicant_only)
    df_import <- dplyr::filter(df_import, stringr::str_detect(distinct_id, "^applicant"))
  
  #clean up event
  df_import <- df_import %>% 
    dplyr::mutate(
      provider = stringr::str_extract(event, "Pinwheel|Argyle"),
      event = stringr::str_remove(event, "Pinwheel|Argyle")
    )
  
  #drop page view events - no property data useful in analysis
  df_import <- df_import %>% 
    dplyr::filter(event != "CbvPageView")
  
  #remove events without CBV flow id (case workers + timeouts)
  df_import <- df_import %>% 
    dplyr::filter(!is.na(cbv_flow_id))
  
  #add pilot name and state
  df_import <- df_import %>% 
    set_pilot()
}


#' Set Pilots
#'
#' Standardizes the naming of the pilots and period for analysis.
#'
#' @param df data from json file
#'
#' @returns dataframe with the pilot state and pilot name included
#' @export
#' 
set_pilot <- function(df){
  
  #add and fill fill missing client_agency_ids
  df <- df |>
    dplyr::mutate(client_agency_id = properties$client_agency_id) |>
    dplyr::group_by(distinct_id) |>
    tidyr::fill(client_agency_id, .direction = "downup") |>
    dplyr::ungroup() 
  
  #remove any sandbox (and missing)
  df <- df %>% 
      dplyr::filter(client_agency_id != "sandbox")
  
  #set pilot state
  df <- df %>% 
    dplyr::mutate(pilot_state = client_agency_id %>% 
                    stringr::str_sub(end = 2) %>% 
                    toupper) 
  
  #set pilot period
  df_pilot <- df %>%
    dplyr::left_join(pilot_pds, by = c("pilot_state" = "state"), 
              relationship = "many-to-many") %>%
    dplyr::filter(timestamp >= start_date & timestamp <= end_date) %>%
    dplyr::select(-c(name, start_date, end_date, client_agency_id))
  
  #order pilot name
  df_pilot <- df_pilot %>% 
    dplyr::mutate(pilot = factor(pilot, unique(pilot_pds$pilot)))
  
  #relocate
  df_pilot <- df_pilot %>% 
    dplyr::relocate(pilot_state, pilot, .after = timestamp)
  
  return(df)
      
}




#' Extract Properties from Nested Column
#'
#' Extracts key columns from a nested `properties` column in a data frame and
#' creates new columns at the top level. The function always extracts a core set
#' of properties and allows for flexible addition of extra columns through the
#' ellipsis (`...`) parameter.
#'
#' @param df A data frame or tibble containing a nested `properties` column.
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Additional column specifications
#'   to extract from the `properties` column. These should be provided as
#'   name-value pairs where the name is the new column name and the value is
#'   the expression to extract (e.g., `user_id = properties$user_id`).
#'
#' @return A data frame with the same structure as `df` but with additional
#'   columns extracted from the `properties` nested column. The following core
#'   columns are always created:
#'   \itemize{
#'     \item `device_type`: Device type from properties
#'     \item `origin`: Origin from properties
#'     \item `employer_name`: Employer name from employment properties
#'     \item `seconds_since_invitation`: Time since invitation in seconds
#'     \item `help_topic`: Help topic, with section overriding topic if present
#'     \item `help_section`: Help section from properties
#'   }
#'
#' @details
#' The function first extracts a predefined set of core columns from the nested
#' `properties` column. The `help_topic` column is conditionally set to
#' `help_section` if `help_section` is not NA, otherwise it retains the value
#' from `properties$topic`.
#'
#' Additional columns can be specified using the `...` parameter, allowing for
#' flexible extraction of other properties without modifying the function.
#'
#' @examples
#' \dontrun{
#' # Basic usage with core columns only
#' df_processed <- extract_properties(df_import)
#'
#' # With additional columns
#' df_processed <- extract_properties(
#'   df_import,
#'   user_id = properties$user_id,
#'   timestamp = properties$timestamp,
#'   session_duration = properties$session_duration
#' )
#' }
#'
#'
#' @export
extract_properties <- function(df, ...) {
  # Define the core columns that are always extracted
  df <- df |>
    mutate(
      device_type = properties$device_type,
      origin = properties$origin,
      employer_name = properties$employment_employer_name,
      seconds_since_invitation = properties$seconds_since_invitation,
      help_topic = properties$topic,
      help_section = properties$section,
      help_topic = ifelse(!is.na(help_section), help_section, help_topic)
    )
  
  # Capture additional column specifications
  additional_cols <- enquos(...)
  
  # If additional columns are specified, add them
  if (length(additional_cols) > 0) {
    df <- df |>
      mutate(!!!additional_cols)
  }
  
  return(df)
}

