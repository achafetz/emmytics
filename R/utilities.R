#' Check if data exists and return empty tibble if not
#'
#' @param data An object to check (character vector, dataframe, list, etc.)
#'
#' @return The original data if it exists, or an empty tibble with a warning
#' @keywords internal

validate_data <- function(data) {
  
  if (is.null(data) || length(data) == 0) {
    cli::cli_alert_danger("No data found. Returning empty tibble.")
    return(tibble::tibble())
  }
  
  invisible(data)
}