# In R/colors.R
dsac_colors <- c(
  navy = "#103D68",
  teal = "#136A5D",
  cranberry = "#6A1344",
  gold = "#EFAC2F",
  light_navy = "#63789D",
  pale_navy = "#C1C9D7",
  light_teal = "#5A9088",
  pale_teal = "#D9E8E5",
  light_cranberry = "#842F66",
  dark_navy = "#123054"
)

# Create individual objects that reference the vector
dsac_navy <- dsac_colors["navy"] %>% unname()
dsac_teal <- dsac_colors["teal"] %>% unname()
dsac_cranberry <- dsac_colors["cranberry"] %>% unname()
dsac_gold <- dsac_colors["gold"] %>% unname()
dsac_light_navy <- dsac_colors["light_navy"] %>% unname()
dsac_pale_navy <- dsac_colors["pale_navy"] %>% unname()
dsac_light_teal <- dsac_colors["light_teal"] %>% unname()
dsac_pale_teal <- dsac_colors["pale_teal"] %>% unname()
dsac_light_cranberry <- dsac_colors["light_cranberry"] %>% unname()
dsac_dark_navy <- dsac_colors["dark_navy"] %>% unname()

usethis::use_data(dsac_colors, dsac_navy, dsac_teal, dsac_cranberry, 
                  dsac_gold, dsac_light_navy, dsac_pale_navy, 
                  dsac_light_teal, dsac_pale_teal, dsac_light_cranberry, 
                  dsac_dark_navy, overwrite = TRUE)
