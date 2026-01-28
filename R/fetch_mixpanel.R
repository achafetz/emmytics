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
#' raw_data <- fetch_mixpanel_data(params)
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
  
  cli::cli_alert_info("Fetching data from Mixpanel API...")
  
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
  
  cli::cli_alert_success("Successfully fetched data from API.")
  
  return(httr::content(response, as = "text", encoding = "UTF-8"))
  
}


#' Load Environment Variables
#'
#' Internal helper to load credentials from .env file.
#' 
#' Credentials should be stored in a .env.local file in the project's root 
#' folder. This function will use dotenv to load the variables from the
#' .env.local file in as environment variables to be accessed during the API 
#' call.
#'
#' @param env_path path to .env file
#' @param req_vars required variables, default = c("MIXPANEL_SERVICE_ACCOUNT_USERNAME", "MIXPANEL_SERVICE_ACCOUNT_SECRET", "MIXPANEL_PROJECT_ID")
#' @return named list of credentials
#' @keywords internal

load_env <- function(env_path,
                     req_vars = c("MIXPANEL_SERVICE_ACCOUNT_USERNAME", "MIXPANEL_SERVICE_ACCOUNT_SECRET", "MIXPANEL_PROJECT_ID")){
  
  #path to .env.local file
  if(missing(env_path) || is.null(env_path)){
    project_root <- dirname(getwd())
    env_path <- file.path(project_root, ".env.local")
  }
  
  #check if there is a .env.local file
  if(!file.exists(env_path))
    cli::cli_abort(c("Cannot find {.file .env.local} file at the expected path",
                     i = "Expected path = {.file {env_path}}",
                     i = "Use {.code setup_env()} to create a {.file .env.local} file"
                     ))
  
  #load .env.local
  dotenv::load_dot_env(env_path)
  
  #check if all the required variables are there
  missing_vars <- req_vars[!nzchar(Sys.getenv(req_vars))]
  
  if (length(missing_vars) > 0)
    cli::cli_abort("Missing environment variable{?s}: {.code {paste(missing_vars, collapse = ', ')}}")
  
  invisible(TRUE)
  
}