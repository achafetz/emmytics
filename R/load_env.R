#' Load Environment Variables
#'
#' Helper to load credentials from .env file.
#' 
#' Credentials should be stored in a .env.local file in the project's root 
#' folder. This function will use dotenv to load the variables from the
#' .env.local file in as environment variables to be accessed during the API 
#' call.
#'
#' @param env_path path to .env file
#' @param req_vars required variables, default = c("MIXPANEL_SERVICE_ACCOUNT_USERNAME", "MIXPANEL_SERVICE_ACCOUNT_SECRET", "MIXPANEL_PROJECT_ID")
#' @return named list of credentials
#' @export
#' @family env

load_env <- function(env_path,
                     req_vars = c("MIXPANEL_SERVICE_ACCOUNT_USERNAME", "MIXPANEL_SERVICE_ACCOUNT_SECRET", "MIXPANEL_PROJECT_ID")){
  
  #path to .env.local file
  if(missing(env_path) || is.null(env_path)){
    project_root <- dirname(getwd())
    env_path <- file.path(project_root, ".env.local")
  }
  
  #check if there is a .env.local file
  if(!file.exists(env_path))
    cli::cli_abort(c("Cannot find {.file .env.local} file at the expected path",
                     i = "Expected path = {.file {env_path}}",
                     i = "Use {.code setup_env()} to create a {.file .env.local} file"
    ))
  
  #load .env.local
  dotenv::load_dot_env(env_path)
  
  #check if all the required variables are there
  missing_vars <- req_vars[!nzchar(Sys.getenv(req_vars))]
  
  if (length(missing_vars) > 0)
    cli::cli_abort("Missing environment variable{?s}: {.code {paste(missing_vars, collapse = ', ')}}")
  
  invisible(TRUE)
  
}




#' Setup environment file
#'
#' This function creates a .env.local file with API key placeholders if it doesn't
#' exist, and ensures the file is added to .gitignore to prevent accidental commits.
#'
#' @param overwrite Logical. If TRUE, overwrites existing .env.local file. Default is FALSE.
#' @return Invisible NULL. Prints messages about actions taken.
#' @export
#' @family env
setup_env_file <- function(overwrite = FALSE) {
  
  # Define the .env.local file path
  env_file <- ".env.local"
  
  # Define the template content
  env_template <- "# ##############################################################################
# This file contains API keys that must be provisioned by each developer as
# part of onboarding.
# ##############################################################################

# ##############################################################################
# Mixpanel analytics keys

MIXPANEL_PROJECT_ID=3511732
MIXPANEL_SERVICE_ACCOUNT_USERNAME=
MIXPANEL_SERVICE_ACCOUNT_SECRET=

"
  
  # Step 1: Create .env.local file if it doesn't exist
  if (!file.exists(env_file)) {
    base::writeLines(env_template, env_file)
    cli::cli_alert_success("Created {.file {env_file}} template file")
  } else if (overwrite) {
    base::writeLines(env_template, env_file)
    cli::cli_alert_warning("Overwrote existing {.file {env_file}} file")
  } else {
    cli::cli_alert_info("{.file {env_file}} already exists. Use {.code overwrite = TRUE} to replace it.")
  }
  
  # Step 2: Add .env.local to .gitignore using usethis
  tryCatch({
    usethis::use_git_ignore(env_file)
    cli::cli_alert_success("Added {.file {env_file}} to {.file .gitignore}")
  }, error = function(e) {
    cli::cli_alert_danger("Failed to update {.file .gitignore}: {e$message}")
  })
  
  # Step 3: Add to .Rbuildignore if in a package
  if (file.exists("DESCRIPTION")) {
    tryCatch({
      usethis::use_build_ignore(env_file)
      cli::cli_alert_success("Added {.file {env_file}} to {.file .Rbuildignore}")
    }, error = function(e) {
      cli::cli_alert_danger("Failed to update {.file .Rbuildignore}: {e$message}")
    })
  }
  
  # Provide next steps
  cli::cli_h2("Next Steps")
  cli::cli_ol(c(
    "Contact one of the EMMY engineers for the shared credentials",
    "Edit {.file {env_file}} and add the Mixpanel API keys",
    "Never commit this file to version control",
    "Use {.code load_env()} to load the environment variables"
  ))
  
  invisible(NULL)
}