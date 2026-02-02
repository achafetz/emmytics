#' Cache Mixpanel Data
#'
#' Saves cleaned Mixpanel data to disk in NDJSON format and can be opened
#' with jsonlite::stream_in() or arrow::read_json_arrow().
#'
#' @param df A tibble containing cleaned Mixpanel event data
#' @param file_path file path for the cached file
#'
#' @return exports file and returns formatted data frame
#' @export
#'
#' @examples
#' \dontrun{
#' #' # Save as JSON (default)
#' cache_mixpanel(df, "mixpanel_data_2025-11-16_to_2025-12-19.json")
#' }

cache_mixpanel <- function(df, file_path) {
  
  cli::cli_progress_step("Caching data", spinner = TRUE)
  
  # Validate data exists before proceeding
  validate_data(df)
  
  # Convert to list format for JSON export
  json_data <- df %>%
    dplyr::mutate(timestamp = as.character(timestamp),
                  properties = purrr::map(properties, standardize_properties)
                  )
    
  #export
  jsonlite::stream_out(json_data, file(file_path), verbose = FALSE)
  
  # Get file size for user feedback
  file_size <- file.info(file_path)$size
  file_size_mb <- round(file_size / 1024^2, 2)
  
  cli::cli_inform(c(
    v = "Clean data saved locally",
    i = "path = {.file {file_path}}",
    i = "size = ({file_size_mb} MB)"
  ))
  
  json_data <- json_data %>% 
    dplyr::mutate(timestamp = lubridate::as_datetime(timestamp))
  
  return(json_data)
}


#' Helper function to standardize any field that might be inconsistent
#'
#' @param prop property/field to standarized
#' 
#' @keywords internal
#'
# More robust helper function
standardize_properties <- function(prop) {
  if (is.null(prop) || !is.list(prop)) {
    return(prop)
  }
  
  purrr::map(prop, function(field) {
    # Handle NULL
    if (is.null(field)) {
      return(NA_character_)
    }
    
    # If it's a data frame, convert to JSON string
    if (is.data.frame(field)) {
      return(jsonlite::toJSON(field, auto_unbox = TRUE))
    }
    
    # If it's a list (array or object)
    if (is.list(field)) {
      # Try to flatten it
      tryCatch({
        # If it's a simple vector-like list, collapse it
        if (all(sapply(field, function(x) length(x) == 1 && !is.list(x)))) {
          return(paste(unlist(field), collapse = ", "))
        } else {
          # Complex nested structure - convert to JSON string
          return(jsonlite::toJSON(field, auto_unbox = TRUE))
        }
      }, error = function(e) {
        # Fallback: convert to JSON string
        return(jsonlite::toJSON(field, auto_unbox = TRUE))
      })
    }
    
    # For atomic vectors with length > 1
    if (length(field) > 1) {
      return(paste(field, collapse = ", "))
    }
    
    # Return as-is for simple atomic values
    return(as.character(field))
  })
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
  json <- arrow::read_json_arrow(file_path)

  #convert to tibble
  df <- json %>%
    tibble::as_tibble() %>% 
    dplyr::mutate(timestamp = lubridate::as_datetime(timestamp))
    purrr::map_dfr(~ tibble::tibble(
      event = .x$event,
      properties = list(.x$properties),
      timestamp = lubridate::as_datetime(.x$timestamp)
    ))

  cli::cli_alert_success("Loaded {nrow(df)} events")
  
  return(df)
}