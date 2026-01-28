#' Fetch Data from Mixpanel API
#'
#' Retrieves raw event data from the Mixpanel Export API for a specified date range.
#'
#' @param params a named list containing API parameters (from_date, to_date, client_agency, etc.)
#' @param env_path path to the .env file containing credentials. Default is ".env.local"
#'
#' @return A character string containing newline-delimited JSON, or NULL if the request fails
#' @export
#'
#' @examples
#' \dontrun{
#' params <- list(from_date = "2025-11-16", to_date = "2025-12-19")
#' raw_data <- fetch_mixpanel(params)
#' }
#' 
fetch_mixpanel <- function(params, env_path){
  
  #check credentials and load them into the environment
  load_env(env_path)
  
  #store loaded mixpanel credentials as variables for GET call
  sa_username <- Sys.getenv("MIXPANEL_SERVICE_ACCOUNT_USERNAME")
  sa_secret <- Sys.getenv("MIXPANEL_SERVICE_ACCOUNT_SECRET")
  project_id <- Sys.getenv("MIXPANEL_PROJECT_ID")
  
  # Add project_id to params
  params$project_id <- project_id
  
  #api endpoint url
  mixpanel_url = "https://data.mixpanel.com/api/2.0/export"
  
  cli::cli_progress_step("Fetching data from Mixpanel API...", spinner = TRUE)
  
  #make API request
  response <- tryCatch({
    httr::GET(
      url = mixpanel_url,
      httr::authenticate(sa_username, sa_secret),
      httr::add_headers(accept = "text/plain"),
      query = params
    )
  }, error = function(e) {
    cli::cli_alert_danger("API request failed: {e$message}")
    return(NULL)
  })
  
  # Check response status
  if (is.null(response))
    return(NULL)
  
  if (httr::http_error(response)) {
    cli::cli_alert_danger("API returned status {httr::status_code(response)}")
    return(NULL)
  }
  
  cli::cli_progress_step("Successfully fetched data from API.")
  
  return(httr::content(response, as = "text", encoding = "UTF-8"))
  
}
