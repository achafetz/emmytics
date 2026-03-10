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
#' df_mp <- mp_path %>%
#'   set_names() %>%
#'   map(~ read_mixpanel(.x, drop_prop = FALSE)) %>%
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
  
  unique(df$pilot) %>% dplyr::last() %>% as.character()
  
}


#' Identify Pilot Week
#' 
#' To assist in comparisons across and within pilots, it can be useful to look 
#' at what is happening each week. This function sets the week based on the
#' event's timestamp. The default is to calculate the week from the time elapsed
#' from the starting date of the pilot but it can also be calculated using 
#' Sunday as the start of each week.
#'
#' @param df mixpanel dataframe
#' @param type week calculated by time "elapsed" (default) or "week floor" 
#'
#' @returns a data frame with a new column for pilot week
#' @export
#'
#' @examples
#' \dontrun{
#' df <- add_pilot_week(df)
#'}
add_pilot_week <- function(df, type = "elapsed"){
  
  if (type == "elapsed") {
    
    #pilot starts to merge on to df to calc duration
    pilot_start <- pilot_pds %>% 
      dplyr::select(pilot, pilot_state = state, pilot_start = start_date)
    
    #change start for LA Feb 2026
    pilot_start <- pilot_start %>% 
      dplyr::mutate(pilot_start = 
                      dplyr::case_when(pilot == "Feb 2026" ~ as.Date("2026-02-19"),
                                       TRUE ~ as.Date(pilot_start))
                    )
    
    #merge on start day by pilot
    df <- df %>% 
      dplyr::left_join(pilot_start,
                       by = dplyr::join_by(pilot_state, pilot))
    
    #calculate pilot week by days elapsed
    df %>% 
      dplyr::mutate(
        pilot_day = lubridate::as_date(timestamp),
        pilot_days_elapsed = as.integer(pilot_day - pilot_start),
        pilot_wk =  floor(pilot_days_elapsed / 7) + 1,
        # pilot_wk = str_glue("wk{pilot_wk}") %>%  as.character(),
        .after = pilot
      ) %>%  
      dplyr::select(-c(pilot_start, pilot_day, pilot_days_elapsed)) 
      
  } else {
    
    df %>% 
      dplyr::mutate(week = timestamp %>% 
                      lubridate::floor_date("weeks") %>%  
                      lubridate::as_date()
      ) %>%  
      dplyr::group_by(pilot) %>% 
      dplyr::mutate(pilot_wk = as.integer((week - min(week)) / 7) + 1,
                      # stringr::str_glue("wk{as.integer((week - min(week)) / 7) + 1}"),
                    .after = pilot) %>% 
      dplyr::ungroup() %>%  
      dplyr::select(-week)
  }
  
}
