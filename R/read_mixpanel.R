
#' Read in Mixpanel data
#' 
#' This function importants and applies standardized munging a Mixpanel dataset. 
#' It expects anNDJSON file input downloaded via `get_mixpanel_data`. The function  
#' extracts key fields from properties, distinct_id and cbv_flow_id, and allows 
#' the user to provide their own fields they want to extract. It also identifies
#' the specific pilot periods for use in analysis.
#' 
#' @param file filepath to ndjson, downloaded via `get_mixpanel_data`
#' @param ... <[`dynamic-dots`][rlang::dyn-dots]> Additional column specs
#'   to extract from the `properties` column. These should be provided as
#'   name-value pairs where the name is the new column name and the value is
#'   the expression to extract (e.g., `user_id = properties$user_id`).
#' @param applicant_only keep only applicant data, dropping case worker and NA
#'  default = TRUE
#' @param drop_prop drop the nested properties column? default = FALSE
#'
#' @returns converts json to a formatted tibble
#'
#' @examples
#' \dontrun{
#' # retrieve pilot data (LA Nov 2025)
#' get_mixpanel_data("2025-11-16", "2025-12-19", "la_ldh")
#'
#' #path to json file downloaded
#' path <- "mixpanel_data_la_ldh_2025-11-16_to_2025-12-19.json"
#' 
#' #read in data with specific properties
#' df_la_nov <- read_mixpanel(path)
#'   
#' #read in data with specific properties
#' df_la_nov_extra <- read_mixpanel(path, 
#'         device_type = properties$device_type,
#'         origin = properties$origin)
#'   
#' }
#' @export
#' 
read_mixpanel <- function(file, ..., applicant_only = TRUE, drop_prop = FALSE){
  
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
  df_import <- extract_properties(df_import, 
                                  distinct_id = properties$distinct_id,
                                  cbv_flow_id = properties$cbv_flow_id)
  
  #add any additional properties a user provides
  df_import <- extract_properties(df_import, ...)
  
  #clean up event
  df_import <- df_import %>% 
    dplyr::mutate(
      provider = stringr::str_extract(event, "Pinwheel|Argyle"),
      event = stringr::str_remove(event, "Pinwheel|Argyle")
    )
  
  #subset to applicant only?
  if(applicant_only)
    df_import <- dplyr::filter(df_import, stringr::str_detect(distinct_id, "^applicant"))
  
  #drop page view events - no property data useful in analysis
  df_import <- df_import %>% 
    dplyr::filter(event != "CbvPageView")
  
  #remove events without CBV flow id (case workers + timeouts)
  df_import <- df_import %>% 
    dplyr::mutate(cbv_flow_id = ifelse(event == "CaseworkerInvitedApplicantToFlow", 999999, cbv_flow_id)) %>% 
    dplyr::filter(!is.na(cbv_flow_id)) %>%
    dplyr::mutate(cbv_flow_id = ifelse(event == "CaseworkerInvitedApplicantToFlow", NA_integer_, cbv_flow_id))
  
  #add pilot name and state
  df_import <- set_pilot(df_import)
    
  #filter pilot state (a pull might errantly contain two states)
  plt_agencies <- unique(pilot_pds$client_agency) %>% tolower() %>% paste0(collapse = "|")
  if(stringr::str_detect(file, stringr::str_glue("_({plt_agencies})_"))){
    plt_state_sel <- file %>% 
      stringr::str_extract(plt_agencies) %>% 
      stringr::str_sub(end = 2) %>% 
      toupper()

    df_import <- df_import %>% 
      dplyr::filter(pilot_state == plt_state_sel)
  }
    
  #reorder variables
  df_import <- df_import %>%
    dplyr::relocate(distinct_id, cbv_flow_id, timestamp, pilot_state, pilot, .before = 1)
  
  #arrange time descending (most recent events on top by user)
  # df_import <- df_import %>%
  #   arrange(distinct_id, desc(timestamp))
  
  #drop properties
  if(drop_prop == TRUE)
    df_import <- dplyr::select(df_import, -properties)
  
  return(df_import)
}


#' Set Pilots
#'
#' Standardizes the naming of the pilots and period for analysis.
#'
#' @param df data from json file
#'
#' @returns dataframe with the pilot state and pilot name included
#' @export
#' @family pilot
#' @seealso \code{\link{pilot_pds}}, \code{\link{return_latest_pilot}}
#' 
set_pilot <- function(df){
  
  #add and fill fill missing client_agency_ids
  df <- df %>%
    extract_properties(client_agency_id = properties$client_agency_id) %>% 
    dplyr::group_by(distinct_id) %>%
    tidyr::fill(client_agency_id, .direction = "downup") %>%
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
    dplyr::select(
      -c(name, start_date, end_date, client_agency_id, client_agency))
  
  #order pilot name
  df_pilot <- df_pilot %>% 
    dplyr::mutate(pilot = factor(pilot, unique(pilot_pds$pilot)))
  
  #relocate
  df_pilot <- df_pilot %>% 
    dplyr::relocate(pilot_state, pilot, .after = timestamp)
  
  return(df_pilot)
      
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
#'   columns extracted from the `properties` nested column.
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
  
  # Helper function to safely unnest list columns
  unnest_if_list <- function(x) {
    if (is.list(x) && !is.data.frame(x)) {
      purrr::map_chr(x, ~ if(is.null(.x) || length(.x) == 0) NA_character_ else as.character(.x[[1]]))
    } else {
      x
    }
  }
  
  # # Define the core columns that are always extracted
  # df <- df %>%
  #   dplyr::mutate(
  #     device_type = properties$device_type,
  #     origin = properties$origin,
  #     employer_name = properties$employment_employer_name,
  #     seconds_since_invitation = properties$seconds_since_invitation,
  #     help_topic = properties$topic,
  #     help_section = properties$section,
  #     # help_topic = ifelse(!is.na(help_section), help_section, help_topic)
  #   )
  
  # Capture additional column specifications
  additional_cols <- dplyr::enquos(...)
  
  # If additional columns are specified, add them
  if (length(additional_cols) > 0) {
    df <- df %>%
      dplyr::mutate(!!!additional_cols)
  }
  
  # Unnest any list columns that were created
  df <- df %>%
    dplyr::mutate(dplyr::across(dplyr::everything(), unnest_if_list))
  
  return(df)
}

