#' Get Mixpanel Data with Caching
#'
#' Main function to fetch, parse, deduplicate, and cache Mixpanel data.
#'
#' @param from_date Start date in 'YYYY-MM-DD' format
#' @param to_date End date in 'YYYY-MM-DD' format
#' @param client_agency if provided, will filter down by specific agency (eg la_ldh)
#' @param cache_dir defaults to working directory 
#' @param force_reload Logical. If TRUE, bypass cache and fetch fresh data
#'
#' @return A tibble containing cleaned, deduplicated Mixpanel events
#' @export
#'
#' @examples
#' \dontrun{
#' df <- get_mixpanel_data("2025-11-16", "2025-12-19")
#' }

get_mixpanel_data <- function(from_date, to_date, client_agency, cache_dir = ".", force_reload = FALSE) {
  
  if(missing(client_agency) || is.null(client_agency || client_agency != ""))
    client_agency <- "all"
  
  # Create base file name
  file_base <- stringr::str_glue("mixpanel_data_{client_agency}_{from_date}_to_{to_date}.json")
  file_path <- file.path(cache_dir, file_base)
  
  # Load cached file if it exists and don't rerun API
  if (file.exists(file_path) && !force_reload) {
    df_clean <- load_cached_mixpanel(file_name)
    return(df_clean)
  }
  
  # Set params for API
  params <- list(
    from_date = from_date,
    to_date = to_date
  )
  
  # Add client_agency filter if provided
  if (!client_agency != "all")
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