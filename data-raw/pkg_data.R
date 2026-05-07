## pilot periods

pilot_pds <- tibble::tribble(
                       ~name, ~state, ~client_agency,  ~start_date,    ~end_date,
            "LA LWC May run",   "LA",       "la_ldh", "2025-05-18", "2025-06-30",
  "AZ Constrained MAC Pilot",   "AZ",       "az_des", "2025-06-13", "2025-08-13",
     "AZ Expanded MAC Pilot",   "AZ",       "az_des", "2025-08-14", "2025-09-04",
         "LA LWC August Run",   "LA",       "la_ldh", "2025-08-17", "2025-09-30",
       "LA LWC November Run",   "LA",       "la_ldh", "2025-11-16", "2025-12-19",
       "LA LWC February Run",   "LA",       "la_ldh", "2026-02-14", "2026-03-22",
"LA LWC March Run (Rolling)",   "LA",       "la_ldh", "2026-03-23", "2026-12-31",
    "NH April Run (Ongoing)",   "NH",      "nh_dhhs", "2026-04-27", "2026-12-31",
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


## Timezones

# timezone lookup (uses IANA timezone strings, OlsonNames())
pilot_timezones <- tibble::tribble(
  ~pilot_state, ~timezone,
  "LA",         "America/Chicago",
  "AZ",         "America/Phoenix",  
  "NH",         "America/New_York",
  "MT",         "US/Mountain"
)

usethis::use_data(pilot_timezones, overwrite = TRUE)

#Events and properties
info <- pilot_pds %>%
  dplyr::filter(state == "LA", pilot == "Feb 2026") %>%
  dplyr::select(start_date, end_date, client_agency) %>%
  dplyr::mutate(dplyr::across(c(start_date, end_date),
                \(x) as.character(x))) %>%
  as.list()

response <- get_mixpanel_data(info$start_date, info$end_date,
                              client_agency = info$client_agency)
event_properties <- response |>
  dplyr::mutate(property = purrr::map(properties, names)) %>% 
  tidyr::unnest(property) %>% 
  dplyr::distinct(event, property) %>% 
  dplyr::arrange(event, property) %>% 
  dplyr::mutate(
    event_standard = stringr::str_remove(event, "Pinwheel|Argyle"),
    key_event = event_standard %in% key_events,
    .after = event
    )

usethis::use_data(event_properties, overwrite = TRUE)
