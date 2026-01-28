#' Setup environment file
#'
#' This function creates a .env.local file with API key placeholders if it doesn't
#' exist, and ensures the file is added to .gitignore to prevent accidental commits.
#'
#' @param overwrite Logical. If TRUE, overwrites existing .env.local file. Default is FALSE.
#' @return Invisible NULL. Prints messages about actions taken.
#' @export
setup_env_file <- function(overwrite = FALSE) {
  
  # Define the .env.local file path
  env_file <- ".env.local"
  
  # Define the template content
  env_template <- "# ##############################################################################
# This file contains API keys that must be provisioned by each developer as
# part of onboarding.
# ##############################################################################

# ##############################################################################
# MixPanel analytics keys

MIXPANEL_PROJECT_ID=
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
    "Edit {.file {env_file}} and add your API keys",
    "Never commit this file to version control",
    "Use {.code load_env()} to load the environment variables"
  ))
  
  # Add to .gitignore using usethis
  usethis::use_git_ignore(".env.local")
  
  invisible(NULL)
}