#' Flag Completion Status at Event, Session, and/or Applicant Level
#'
#' Creates binary completion flag columns on a web analytics dataframe,
#' indicating whether an applicant completed the target event
#' (\code{ApplicantSharedIncomeSummary}) at the event, session, and/or
#' applicant level.
#'
#' @param df A dataframe containing web analytics data. Must include the
#'   following columns:
#'   \describe{
#'     \item{\code{event}}{Character. The name of the tracked event.}
#'     \item{\code{pilot}}{Character or factor. The pilot group identifier,
#'       used as a grouping variable for session- and applicant-level flags.}
#'     \item{\code{cbv_flow_id}}{Character or numeric. A unique session
#'       identifier. Required when \code{"session"} is included in \code{type}.}
#'     \item{\code{distinct_id}}{Character or numeric. A unique applicant
#'       identifier. Required when \code{"applicant"} is included in \code{type}.}
#'   }
#' @param type Character vector specifying which completion flags to generate.
#'   One or more of:
#'   \describe{
#'     \item{\code{"event"}}{Adds \code{completed_event}: \code{TRUE} if the
#'       row's event is \code{ApplicantSharedIncomeSummary}, \code{FALSE}
#'       otherwise.}
#'     \item{\code{"session"}}{Adds \code{completed_session}: \code{TRUE} if
#'       any event within the same \code{pilot} + \code{cbv_flow_id} session
#'       is a completion event.}
#'     \item{\code{"applicant"}}{Adds \code{completed_applicant}: \code{TRUE}
#'       if any event across all sessions for the same \code{pilot} +
#'       \code{distinct_id} applicant is a completion event.}
#'   }
#'   Defaults to \code{c("event", "session", "applicant")} (all three).
#'
#' @return A dataframe with the same rows as \code{df}, with one or more of
#'   the following columns appended depending on \code{type}:
#'   \describe{
#'     \item{\code{completed_event}}{Logical. Row-level completion flag.
#'       Included only if \code{"event"} is in \code{type}.}
#'     \item{\code{completed_session}}{Logical. Session-level completion flag.
#'       Included only if \code{"session"} is in \code{type}.}
#'     \item{\code{completed_applicant}}{Logical. Applicant-level completion
#'       flag. Included only if \code{"applicant"} is in \code{type}.}
#'   }
#'
#' @details
#' The target completion event is defined internally as
#' \code{"ApplicantSharedIncomeSummary"}. A row-level \code{completed_event}
#' flag is first created, then session- and applicant-level flags are derived
#' by applying \code{any()} within each group. \code{any()} returns \code{TRUE}
#' if at least one value in the group is \code{TRUE}, making the aggregation
#' logic explicit and self-documenting.
#'
#' If \code{"event"} is not included in \code{type}, the intermediate
#' \code{completed_event} column is dropped from the returned dataframe.
#'
#' Grouping configurations for \code{"session"} and \code{"applicant"} are
#' defined internally and applied functionally via \code{purrr::reduce()},
#' making it straightforward to extend the function with additional grouping
#' levels in the future.
#'
#' @examples
#' \dontrun{
#' # Add all three flags (default)
#' df_flagged <- flag_completed(df)
#'
#' # Add only the applicant-level flag
#' df_flagged <- flag_completed(df, type = "applicant")
#'
#' # Add session and applicant flags, but not the raw event-level flag
#' df_flagged <- flag_completed(df, type = c("session", "applicant"))
#' }
#'
#' @export

flag_completed <- function(df, type = c("event", "session", "applicant")) {
  
  type <- match.arg(type, several.ok = TRUE)
  
  # Define the event that counts as "completed"
  completion_event <- "ApplicantSharedIncomeSummary"
  
  # Define grouping columns for each sub-event type
  group_config <- list(
    session   = "cbv_flow_id",
    applicant = "distinct_id"
  )
  
  # Filter config to only requested types
  active_config <- group_config[names(group_config) %in% type]
  
  # Create flag at event level
  df_comp <- df %>%
    dplyr::mutate(completed_event = event == completion_event)
  
  # Functionally apply each grouping transformation
  df_comp <- purrr::reduce(
    names(active_config),
    .init = df_comp,
    .f = function(x, grp_type) {
      id_col   <- active_config[[grp_type]]
      flag_col <- paste0("completed_", grp_type)
      
      x %>%
        dplyr::group_by(pilot, .data[[id_col]]) %>%
        dplyr::mutate(!!flag_col := any(completed_event, na.rm = TRUE)) %>%
        dplyr::ungroup()
    }
  )
  
  # Drop completed_event if not requested
  if (!"event" %in% type) {
    df_comp <- df_comp %>%
      dplyr::select(-completed_event)
  }
  
  return(df_comp)
}
