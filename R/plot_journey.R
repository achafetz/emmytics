#' Create a journey visualization plot
#'
#' @param df a data frame munged by \code{\link{munge_journey}}
#' @param export_fldr if specified, this is the folder path where the file will
#'   be exported to (default = missing, no export) 
#'
#' @return A ggplot object
#' @export
#' @family app_journey
#' @seealso \code{\link{munge_journey}} for how data are munged for viz or 
#'   \code{\link{follow_applicant}} for a tabular view of all events
#' 
#' @importFrom ggplot2 ggplot aes geom_blank geom_line geom_point geom_text
#' @importFrom ggplot2 facet_grid scale_color_identity scale_size_identity
#' @importFrom ggplot2 scale_x_reverse scale_y_discrete coord_cartesian labs theme
#' @importFrom ggplot2 element_blank element_text unit theme_minimal
#' @importFrom ggtext element_markdown
#' 
#' @examples
#' \dontrun{
#' df_mp <- read_parquet(mp_path)
#' 
#' df_mp %>%
#'   munge_journey("applicant-123456") %>%
#'   plot_journey(export = "../Images/")
#' }

plot_journey <- function(df, export_fldr){
  
  #require function for running fucntion
  # rlang::check_installed("ggplot2", reason = "to create plots")
  # rlang::check_installed("ggtext", reason = "for rendering markdown in plot")
  
  #require Font Awesome
  if (!("Font Awesome 7 Free" %in% systemfonts::system_fonts()$family)) {
    cli::cli_abort(c(
      "x" = "The {.strong Font Awesome 7 Free} font is not installed on your system.",
      "i" = "Download and install it from: {.url https://fontawesome.com/download}"
    ))
  }
  
  #remove any missing primary events
  df_viz <- df %>%
    dplyr::filter(!is.na(primary_event))
  
  #craft viz
  v <- df_viz %>%
    ggplot(aes(y = rev(primary_event))) + #forcats::fct_rev
    geom_blank(aes(x = 10)) +
    geom_line(aes(row), color = "#909090") +
    geom_line(aes(x = 1, group = cbv_flow_id), na.rm = TRUE, color = "#909090") +
    geom_point(aes(plot_secondary), na.rm = TRUE, size = 4, color = "#909090") +
    geom_point(aes(plot_primary, color = fill_color), na.rm = TRUE, size = 11) +
    geom_text(aes(x = row, label = fa_icon, color = icon_color,
                  vjust = icon_vjust, size = icon_size), na.rm = TRUE, 
              family = "Font Awesome 7 Free", fontface = "bold") +
    facet_grid(~cbv_flow_id) +
    scale_color_identity() +
    scale_size_identity() +
    scale_x_reverse() +
    scale_y_discrete(labels = rev(key_events_clean_br), position = "right") +
    coord_cartesian(clip = "off") +
    theme_minimal() + # si_style_nolines() +
    labs(x = NULL, y = NULL,
         caption = "Source: EMMY Pilot Mixpanel Data") +
    theme(axis.text.x = element_blank(),
          axis.text.y = element_markdown(hjust = 0),
          strip.text = element_text(hjust = 1),
          panel.grid.major = element_blank(),
          panel.spacing = unit(.2, "lines"))
  
  if (!missing(export_fldr) || is.null(export_fldr)) {
    export_path <- file.path(export_fldr, stringr::str_glue("journey_{unique(df_viz$distinct_id)}.png"))
    ggplot2::ggsave(export_path, width = 6.73, height = 5.54)
  }
  
  return(v)
  
}



#' Munge data for journey visualization plot
#'
#' This function provides the initial munging steps to process the data in a way
#' that can then be handled by \code{\link{plot_journey}}
#' @param df Mixpanel dataframe
#' @param applicant an applicant's distinct_id
#' @param pilot_pd can limit this to a particular pilot, eg "Nov 2025"
#'
#' @returns processed dataframe for use with \code{\link{plot_journey}} 
#' @export
#' 
#' @family app_journey
#' @seealso \code{\link{plot_journey}} for visualizing this data or 
#'   \code{\link{follow_applicant}} for a tabular view of all events
#'
#' @examples
#' \dontrun{
#' df_mp <- read_parquet(mp_path)
#' 
#' df_mp %>%
#'   munge_journey("applicant-123456") %>% 
#'   plot_journey(export = "../Images/")
#' }
munge_journey <- function(df, applicant, pilot_pd) {
  
  if(missing(applicant) || is.null(applicant))
    cli::cli_abort("No {.code distinct_id} provided in {.code applicant}")
  
  if(missing(pilot_pd) || is.null(pilot_pd))
    pilot_pd <- unique(df$pilot)
  
  #filter down to specific 
  df_story <- df %>% 
    dplyr::filter(
      distinct_id == applicant,
      pilot %in% pilot_pd
    ) %>%
    dplyr::distinct(pilot, distinct_id, cbv_flow_id, timestamp, event, provider)
  
  #check that data are returned after filter
  validate_data(df_story)
  
  #identify missing events by completing the df
  df_needed <- df_story %>%
    dplyr::distinct(pilot, distinct_id, cbv_flow_id) %>%
    tidyr::crossing(event = factor(key_events, key_events)) %>%
    dplyr::arrange(cbv_flow_id, dplyr::desc(event)) %>%
    dplyr::mutate(event = as.character(event)) %>%
    dplyr::anti_join(
      df_story,
      by = dplyr::join_by(pilot, distinct_id, cbv_flow_id, event)
    )
  
  #complete event dataframe
  df_story <- df_needed %>%
    dplyr::bind_rows(df_story)
  
  df_story <- df_story %>%
    clean_events() %>%
    dplyr::mutate(
      is_primary = event %in% key_events,
      primary_event = dplyr::case_when(is_primary ~ event_clean),
    ) %>%
    dplyr::group_by(cbv_flow_id) %>%
    tidyr::fill(primary_event, .direction = "down") %>%
    dplyr::ungroup() %>%
    dplyr::group_by(cbv_flow_id, primary_event) %>%
    dplyr::mutate(row = dplyr::row_number()) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      primary_event = factor(primary_event, key_events_clean),
      plot_primary = dplyr::case_when(is_primary & row == 1 ~ row),
      plot_secondary = dplyr::case_when(row != 1 ~ row)
    )
  
  #assign icons to important events
  #Icon list - https://fontawesome.com/v4/cheatsheet/
  df_story <- df_story %>%
    dplyr::mutate(
      fa_icon = dplyr::case_when(
        stringr::str_detect(event, "Failed") ~ "\uf071", #fa-exclamation-triangle
        stringr::str_detect(event, "Error") ~ "\uf00d", #fa-times
        event == "ApplicantViewedAgreement" ~ "\uf144", #fa-play-circle
        event == "ApplicantAgreed" ~ "\uf061", # fa-arrow-right
        event == "ApplicantSelectedEmployerOrPlatformItem" ~ "\uf00c", #fa-check
        event == "ApplicantAttemptedLogin" ~ "\uf023", #fa-lock
        event == "ApplicantSucceededWithLogin" ~ "\uf2b5", #fa-handshake-o
        event == "ApplicantViewedPaymentDetails" ~ "\uf002", #fa-search
        event == "ApplicantAccessedMissingResultsPage" ~ "\uf071", #fa-exclamation-triangle
        event == "ApplicantSharedIncomeSummary" ~ "\uf11e", #fa-flag-checkered
        event == "ApplicantSearchedForEmployer" ~ "\uf1e5", #fa-binoculars,
        stringr::str_detect(event, "Time") ~ "\uf254", #fa-hourglass,
        stringr::str_detect(event, "Help") ~ "\uf128" #fa-question,
      ),
      fill_color = ifelse(
        row == 1 & !is.na(timestamp),
        dsac_color['light_navy'],
        "#e0e0e0"
      ),
      icon_color = dplyr::case_when(
        is_primary & row == 1 ~ "white",
        str_detect(event, "Failed|Error|Help") ~ dsac_color['light_cranberry'],
        TRUE ~ "#909090"
      ),
      icon_size = ifelse(is_primary & row == 1, 6, 4),
      icon_vjust = ifelse(is_primary & row == 1, .5, -.8)
    )
  
  return(df_story)
}
