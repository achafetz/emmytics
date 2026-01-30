#' Create Mock Mixpanel Data from Real Dataset
#'
#' Samples a subset of users and returns all their events for testing
#'
#' @param df Full Mixpanel dataset (tibble)
#' @param n_users Number of distinct users to sample
#' @param seed Random seed for reproducibility
#'
#' @return A tibble with sampled events
#' @export
#' 
sample_mixpanel <- function(df, n_users = 20, seed = 123) {
  
  set.seed(seed)
  
  # Extract user IDs from properties
  df_with_users <- df %>%
    dplyr::mutate(
      distinct_id = purrr::map_chr(properties, ~ .x$distinct_id %||% .x$user_id %||% NA_character_)
    ) %>%
    dplyr::filter(
      !is.na(distinct_id),
      stringr::str_detect(distinct_id, "^caseworker", negate = TRUE)
      )
  
  # Sample n_users
  sampled_users <- df_with_users %>%
    dplyr::distinct(distinct_id) %>%
    dplyr::slice_sample(n = n_users) %>%
    dplyr::pull(distinct_id)
  
  # Get all events for those users
  mock_data <- df_with_users %>%
    dplyr::filter(distinct_id %in% sampled_users) %>%
    dplyr::select(-distinct_id)  # Remove temporary column
  
  cli::cli_alert_success(
    "Created mock dataset with {nrow(mock_data)} events from {n_users} users"
  )
  
  return(mock_data)
}