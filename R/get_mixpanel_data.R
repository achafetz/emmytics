#' Get Mixpanel Data with Caching
#'
#' Main function to fetch, parse, deduplicate, and cache Mixpanel data.
#'
#' @param from_date Start date in 'YYYY-MM-DD' format
#' @param to_date End date in 'YYYY-MM-DD' format
#' @param force_reload Logical. If TRUE, bypass cache and fetch fresh data
#'
#' @return A tibble containing cleaned, deduplicated Mixpanel events
#' @export
#'
#' @examples
#' \dontrun{
#' df <- get_mixpanel_data("2025-11-16", "2025-12-19")
#' }

get_mixpanel_data <- function(from_date, to_date, force_reload = FALSE) {
  
  file_name <- stringr::str_glue("mixpanel_data_{from_date}_to_{to_date}.json")
  
  # Check if cached file exists
  if (file.exists(file_name) && !force_reload) {
    cli::cli_alert_info("Loading de-duplicated data from local file: {.file {file_name}}")
    clean_df <- jsonlite::read_json(file_name, simplifyVector = FALSE) %>%
      purrr::map_dfr(~ tibble::tibble(
        event = .x$event,
        properties = list(.x$properties),
        timestamp = lubridate::as_datetime(.x$timestamp)
      ))
    return(clean_df)
  }
  
  # Fetch data from API
  params <- list(
    from_date = from_date,
    to_date = to_date
  )
  
  raw_text <- fetch_mixpanel(params)
  
  #check if data exists before proceeding
  validate_data(raw_text)
  
  # Parse and deduplicate
  df <- parse_mixpanel(raw_text)
  df_clean <- deduplicate_mixpanel(df)
  
  #check if data exists before proceeding
  validate_data(df_clean)
  
  # Save the de-duplicated data for future use
  # Convert to list format for JSON export
  json_data <- df_clean %>%
    dplyr::mutate(timestamp = as.character(timestamp)) %>%
    purrr::pmap(list) %>%
    jsonlite::toJSON(auto_unbox = TRUE, pretty = FALSE)
  
  readr::write_lines(json_data, file_name)
  
  cli::cli_alert_success("Clean, de-duplicated data saved to {.file {file_name}}")
  
  return(df_clean)
}