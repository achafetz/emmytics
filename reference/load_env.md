# Load Environment Variables

Helper to load credentials from .env file.

## Usage

``` r
load_env(
  env_path,
  req_vars = c("MIXPANEL_SERVICE_ACCOUNT_USERNAME", "MIXPANEL_SERVICE_ACCOUNT_SECRET",
    "MIXPANEL_PROJECT_ID")
)
```

## Arguments

- env_path:

  path to .env file

- req_vars:

  required variables, default = c("MIXPANEL_SERVICE_ACCOUNT_USERNAME",
  "MIXPANEL_SERVICE_ACCOUNT_SECRET", "MIXPANEL_PROJECT_ID")

## Value

named list of credentials

## Details

Credentials should be stored in a .env.local file in the project's root
folder. This function will use dotenv to load the variables from the
.env.local file in as environment variables to be accessed during the
API call.

## See also

Other env:
[`setup_env_file()`](https://aaron-chafetz.com/emmytics/reference/setup_env_file.md)
