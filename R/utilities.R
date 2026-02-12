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



#' Return Latest Pilot
#' 
#' This function returns the latest pilot in the dataset, relying on the fact
#' that pilot is a factor variable. Useful when there are multiple pilot periods
#' combined in the same dataframe.
#'
#' @param df a mixpanel dataframe
#'
#' @returns a character vector of the most recent pilot
#' @export
#' @family pilot
#' @seealso \code{\link{pilot_pds}}, \code{\link{set_pilot}}
#'
#' @examples
#' \dontrun{
#' #identify paths for json data for each of the periods
#' mp_paths <- list.files("Data","json", full.names = TRUE)
#'
#' #read in data
#' df_mp <- mp_path |>
#'   set_names() |>
#'   map(~ read_mixpanel(.x, drop_prop = FALSE)) |>
#'   list_rbind(names_to = "source_path")
#' 
#' #store the latest pilot
#' latest <- return_latest_pilot(df_mp)
#' }
return_latest_pilot <- function(df){
  
  if (!is.factor(df$pilot)) {
    #order pilot name
    df <- df %>% 
      dplyr::mutate(pilot = factor(pilot, unique(pilot_pds$pilot)))
  }
  
  levels(df$pilot) |> tail(n=1)
  
}