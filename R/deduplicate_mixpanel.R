#' Deduplicate Mixpanel Events
#'
#' Removes duplicate events based on $insert_id, keeping the most recent occurrence.
#'
#' @param df A tibble containing Mixpanel event data with nested properties
#'
#' @return A deduplicated tibble
#' @export
#'
#' @examples
#' \dontrun{
#' clean_df <- deduplicate_mixpanel_events(df)
#' }
deduplicate_mixpanel <- function(df) {
  
  #check if data exists before proceeding
  validate_data(df)
  
  cli::cli_alert_info("Original event count: {nrow(df)}")
  
  # Extract timestamp and insert_id from nested properties
  df <- df %>%
    dplyr::mutate(timestamp = purrr::map_dbl(properties, ~ {
      time_val <- .x$time %||% .x$timestamp %||% NA_real_
        as.numeric(time_val)
      }),
      insert_id = purrr::map_chr(properties, ~ .x$`$insert_id` %||% NA_character_)) %>%
    # Convert Unix timestamp to datetime
    dplyr::mutate(timestamp = lubridate::as_datetime(timestamp))
  
  # Drop rows where insert_id is missing
  df <- df %>%
    dplyr::filter(!is.na(insert_id))
  
  # Sort by timestamp and keep last occurrence of each insert_id
  df <- df %>%
    dplyr::arrange(timestamp) %>%
    dplyr::distinct(insert_id, .keep_all = TRUE) %>%
    dplyr::select(-insert_id)  # Remove temporary column
  
  cli::cli_alert_info("Event count after de-duplication: {nrow(df)}")
  
  return(df)
  
}