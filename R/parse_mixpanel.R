#' Parse Raw Mixpanel Data to DataFrame
#'
#' Converts newline-delimited JSON text from Mixpanel into a tidy tibble.
#'
#' @param raw_text Character string containing newline-delimited JSON
#'
#' @return A tibble with event and properties columns
#' @export
#'
#' @examples
#' \dontrun{
#' df <- parse_mixpanel_data(raw_text)
#' }
parse_mixpanel <- function(raw_text) {
  
  # Split by newlines and parse each line as JSON
  lines <- stringr::str_split(raw_text, "\n")[[1]]
  lines <- lines[lines != ""]  # Remove empty lines
  
  if (length(lines) == 0)
    return(tibble::tibble())
  
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
  
  if (length(raw_data) == 0)
    return(tibble::tibble())
  
  # Convert to tibble
  # Note: This keeps the nested structure intact
  df <- tibble::tibble(
    event = purrr::map_chr(raw_data, ~ .x$event %||% NA_character_),
    properties = purrr::map(raw_data, ~ .x$properties %||% list())
  )
  
  return(df)
  
}