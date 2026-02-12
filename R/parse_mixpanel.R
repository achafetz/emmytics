#' Parse Raw Mixpanel Data to DataFrame
#'
#' Converts newline-delimited JSON text from Mixpanel into a tidy tibble.
#'
#' @param raw_text Character string containing newline-delimited JSON
#'
#' @return A tibble with event and properties columns
#' @keywords internal
#' @family api
#'
#' @examples
#' \dontrun{
#' df <- parse_mixpanel_data(raw_text)
#' }
parse_mixpanel <- function(raw_text) {
  
  #check if data exists before proceeding
  validate_data(raw_text)
  
  cli::cli_progress_step("Parsing data.", spinner = TRUE)
  
  # Split by newlines and parse each line as JSON
  lines <- stringr::str_split(raw_text, "\n")[[1]]
  lines <- lines[lines != ""]  # Remove empty lines
  
  #check if data exists before proceeding
  validate_data(lines)
  
  # Parse each line as JSON
  raw_data <- purrr::map(lines, function(line) {
    tryCatch({
      jsonlite::fromJSON(line, simplifyVector = FALSE)
    }, error = function(e) {
      cli::cli_alert_danger("Warning: Could not decode line: {line}")
      return(NULL)
    })
  })
  
  # Remove NULL entries (failed parses)
  raw_data <- purrr::compact(raw_data)
  
  #check if data exists before proceeding
  validate_data(raw_data)

  # Convert to tibble
  # Note: This keeps the nested structure intact
  df <- tibble::tibble(
    event = purrr::map_chr(raw_data, ~ .x$event %||% NA_character_),
    properties = purrr::map(raw_data, ~ .x$properties %||% list()),
    timestamp = purrr::map_dbl(properties, ~ {
      time_val <- .x$time %||% .x$timestamp %||% NA_real_
      as.numeric(time_val)
    })
  )
  
  # Convert Unix timestamp to datetime
  df <- df %>% 
    dplyr::mutate(timestamp = lubridate::as_datetime(timestamp))
  
  return(df)
  
}