#' Get Mixpanel Data with Caching
#'
#' Main function to fetch, parse, deduplicate, and cache Mixpanel data.
#'
#' @param from_date Start date in 'YYYY-MM-DD' format
#' @param to_date End date in 'YYYY-MM-DD' format
#' @param client_agency if provided, will filter down by specific agency. Run
#'  `unique(pilot_pds$client_agency)` to get the set of states/agencies.
#' @param events Character vector of event names to fetch. If NULL (default),
#'   all events are returned. E.g. \code{c("ApplicantViewedAgreement", 
#'   "ApplicantSharedIncomeSummary")} 
#' @param cache_dir defaults to working directory 
#' @param force_reload Logical. If TRUE, bypass cache and fetch fresh data
#'
#' @return A tibble containing cleaned, deduplicated Mixpanel events
#' @export
#' @family api
#'
#' @examples
#' \dontrun{
#' 
#' #pull all data over a specific time period
#' df_all <- get_mixpanel_data("2026-02-14", "2026-03-22")
#' 
#' #return just one agency's data over that period
#' df_la <- get_mixpanel_data("2026-02-14", "2026-03-22", 
#'                             client_agency = "la_ldh")
#'                             
#' #use stored information from pilot_pds
#' info <- pilot_pds %>%
#'   filter(state == "LA", pilot == "Feb 2026") %>% 
#'   select(start_date, end_date, client_agency) %>% 
#'   mutate(across(c(start_date, end_date), 
#'                 \(x) as.character(x))) %>% 
#'     as.list()
#'   
#' df_la <- get_mixpanel_data(info$start_date, info$end_date,
#'                            client_agency = info$client_agency)
#'                            
#' #return only specific events
#' bounding_events <- c("ApplicantViewedAgreement", 
#'                      "ApplicantSharedIncomeSummary")
#'                      
#' df_la <- get_mixpanel_data(info$start_date, info$end_date,
#'                            client_agency = info$client_agency,
#'                            events = bounding_events 
#'                            )
#' 
#' }

get_mixpanel_data <- function(from_date, to_date, client_agency, 
                              events, cache_dir = ".", force_reload = FALSE) {
  
  if(missing(client_agency) || is.null(client_agency) || client_agency == "")
    client_agency <- "all"
  
  # Create base file name
  file_base <- stringr::str_glue("mixpanel_data_{client_agency}_{from_date}_to_{to_date}.json")
  file_path <- file.path(cache_dir, file_base)
  
  # Load cached file if it exists and don't rerun API
  if (file.exists(file_path) && !force_reload) {
    df_clean <- load_cached_mixpanel(file_path)
    return(df_clean)
  }
  
  # Set params for API
  params <- list(
    from_date = from_date,
    to_date = to_date
  )
  
  if (!missing(events))
    params$event = jsonlite::toJSON(events, auto_unbox = FALSE)
  
  # Add client_agency filter if provided
  if (client_agency != "all")
    params$where <- stringr::str_glue('properties["client_agency_id"]=="{client_agency}"')
  
  #run API
  raw_text <- fetch_mixpanel(params)
  
  # Parse and deduplicate
  df_clean <- raw_text %>% 
    parse_mixpanel() %>% 
    deduplicate_mixpanel()
  
  #cache as a json
  cache_mixpanel(df_clean, file_path)

  return(df_clean)
}