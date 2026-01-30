
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