
#' Clean Mixpanel events
#'
#' Takes the Mixpanel event names and cleans them up, removing duplicative
#' "Applicant" prefix and adding a space between each work. For example, 
#' "ApplicantAccessedSuccessPage" becomes "Accessed Success Page". This is 
#' useful when presenting out the data.
#'
#' @param df data frame from Mixpanel with even names
#'
#' @returns dataframe with a new column for cleaned names
#' @export
#'
#' @examples
#' \dontrun{
#' df_viz <- df_subset %>% clean_events()
#' }
clean_events <- function(df){
  
  df |> 
    dplyr::mutate(
      event_clean = event |> 
        stringr::str_replace_all("(?<!^)([A-Z])", " \\1") |> 
        stringr::str_remove("Applicant ") |> 
        stringr::str_remove(" Or Platform Item") |> 
        stringr::str_replace("M F A", "MFA") |> 
        stringr::str_replace("C B V", "CBV") |> 
        stringr::str_replace("P D F", "PDF"),
      .after = event
    )
}