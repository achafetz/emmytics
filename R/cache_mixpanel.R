#' Cache Mixpanel Data
#'
#' Saves cleaned Mixpanel data to disk in JSON format.
#'
#' @param df A tibble containing cleaned Mixpanel event data
#' @param file_path file path for the cached file
#'
#' @return Invisibly returns the file path of the saved file
#' @export
#'
#' @examples
#' \dontrun{
#' #' # Save as JSON (default)
#' cache_mixpanel(df, "mixpanel_data_2025-11-16_to_2025-12-19.json")
#' }

cache_mixpanel <- function(df, file_path) {
  
  # Validate data exists before proceeding
  validate_data(df)
  
  # Convert to list format for JSON export
  json_data <- df %>%
    dplyr::mutate(timestamp = as.character(timestamp)) %>%
    purrr::pmap(list) %>%
    jsonlite::toJSON(auto_unbox = TRUE, pretty = FALSE)
    
  #export
  readr::write_lines(json_data, file_path)
  
  # Get file size for user feedback
  file_size <- file.info(file_path)$size
  file_size_mb <- round(file_size / 1024^2, 2)
  
  cli::cli_alert_success(
    "Clean, de-duplicated data saved to {.file {file_path}} ({file_size_mb} MB)"
  )
  
  invisible(file_path)
}




#' Load Cached Mixpanel Data
#'
#' Loads previously cached Mixpanel data from either JSON format.
#'
#' @param file_path File path of the cached file
#'
#' @return A tibble containing the cached Mixpanel event data
#' @export
#'
#' @examples
#' \dontrun{
#' # Load from JSON
#' df <- load_cached_mixpanel("mixpanel_data_2025-11-16_to_2025-12-19.json")
#' }
load_cached_mixpanel <- function(file_path) {
  
  # Check if file exists
  if (!file.exists(file_path))
    return(NULL)

  cli::cli_alert_info("Loading de-duplicated data from {.file {file_path}}...")
  
  # Load data
  df <- jsonlite::read_json(file_path, simplifyVector = FALSE) %>%
    purrr::map_dfr(~ tibble::tibble(
      event = .x$event,
      properties = list(.x$properties),
      timestamp = lubridate::as_datetime(.x$timestamp)
    ))

  cli::cli_alert_success("Loaded {nrow(df)} events")
  
  return(df)
}