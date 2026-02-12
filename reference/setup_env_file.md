# Setup environment file

This function creates a .env.local file with API key placeholders if it
doesn't exist, and ensures the file is added to .gitignore to prevent
accidental commits.

## Usage

``` r
setup_env_file(overwrite = FALSE)
```

## Arguments

- overwrite:

  Logical. If TRUE, overwrites existing .env.local file. Default is
  FALSE.

## Value

Invisible NULL. Prints messages about actions taken.

## See also

Other env:
[`load_env()`](https://aaron-chafetz.com/emmytics/reference/load_env.md)
