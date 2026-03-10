## pilot periods

pilot_pds <- tibble::tribble(
                       ~name, ~state, ~client_agency,  ~start_date,    ~end_date,
            "LA LWC May run",   "LA",       "la_ldh", "2025-05-18", "2025-06-30",
  "AZ Constrained MAC Pilot",   "AZ",       "az_des", "2025-06-13", "2025-08-13",
     "AZ Expanded MAC Pilot",   "AZ",       "az_des", "2025-08-14", "2025-09-04",
         "LA LWC August Run",   "LA",       "la_ldh", "2025-08-17", "2025-09-30",
       "LA LWC November Run",   "LA",       "la_ldh", "2025-11-16", "2025-12-19",
       "LA LWC February Run",   "LA",       "la_ldh", "2026-02-14", "2026-03-20",
          "LA LWC March Run",   "LA",       "la_ldh", "2026-03-22", "2026-04-25"
)


  
pilot_pds <- pilot_pds %>%
  dplyr::mutate(pilot = stringr::str_glue("{lubridate::month(start_date, label = TRUE)} {lubridate::year(start_date)}") %>% as.character()) %>% 
  dplyr::mutate(across(dplyr::contains("date"), lubridate::as_date))


usethis::use_data(pilot_pds, overwrite = TRUE)


## Key events in applicant journey

key_events <- c(
  "ApplicantViewedAgreement",
  "ApplicantAgreed",
  "ApplicantSelectedEmployerOrPlatformItem",
  "ApplicantAttemptedLogin",
  "ApplicantSucceededWithLogin",
  "ApplicantViewedPaymentDetails",
  "ApplicantSharedIncomeSummary"
)

key_events_clean <-
  tibble::tibble(event = key_events) %>%
  clean_events() %>%
  dplyr::pull()

key_events_clean_br <- stringr::str_replace_all(key_events_clean, " ", "\n")

usethis::use_data(key_events, key_events_clean, key_events_clean_br, overwrite = TRUE)
