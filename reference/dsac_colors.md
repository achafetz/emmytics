# DSAC Color Palette

A named vector of hex color codes for DSAC (Data Science and Analytics
Center) branding. This palette includes primary colors and their
lighter/darker variants for use in data visualizations and graphics.

## Usage

``` r
dsac_colors
```

## Format

A named character vector with 10 colors:

- dsac_navy:

  Primary navy blue (#103D68)

- dsac_teal:

  Primary teal (#136A5D)

- dsac_cranberry:

  Primary cranberry (#6A1344)

- dsac_gold:

  Accent gold (#EFAC2F)

- dsac_light_navy:

  Light navy variant (#63789D)

- dsac_pale_navy:

  Pale navy variant (#C1C9D7)

- dsac_light_teal:

  Light teal variant (#5A9088)

- dsac_pale_teal:

  Pale teal variant (#D9E8E5)

- dsac_light_cranberry:

  Light cranberry variant (#842F66)

- dsac_dark_navy:

  Dark navy variant (#123054)

## Examples

``` r
# View all colors
dsac_colors
#>            navy            teal       cranberry            gold      light_navy 
#>       "#103D68"       "#136A5D"       "#6A1344"       "#EFAC2F"       "#63789D" 
#>       pale_navy      light_teal       pale_teal light_cranberry       dark_navy 
#>       "#C1C9D7"       "#5A9088"       "#D9E8E5"       "#842F66"       "#123054" 

# Access a specific color from the vector
dsac_colors["dsac_navy"]
#> <NA> 
#>   NA 
```
