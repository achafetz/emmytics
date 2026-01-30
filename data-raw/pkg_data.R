## pilot periods


pilot_pds <- tibble::tribble(
                       ~name, ~state,  ~start_date,    ~end_date,
            "LA LWC May run",   "LA", "2025-05-18", "2025-06-30",
  "AZ Constrained MAC Pilot",   "AZ", "2025-06-13", "2025-08-13", #actual end time is 19:29 MAT
     "AZ Expanded MAC Pilot",   "AZ", "2025-08-14", "2025-09-15", #actual start time is day before at 19:30 MAT
         "LA LWC August Run",   "LA", "2025-08-17", "2025-09-30",
       "LA LWC November Run",   "LA", "2025-11-16", "2025-12-19"
) 

pilot_pds <- pilot_pds %>% 
  dplyr::mutate(across(dplyr::contains("date"), lubridate::as_date))


usethis::use_data(pilot_pds, overwrite = TRUE)
