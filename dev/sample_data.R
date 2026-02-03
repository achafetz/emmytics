devtools::load_all()

# Set up test parameters
FROM_DATE <- "2025-11-16"
TO_DATE <- "2025-12-19"
CLIENT_AGENCY <- "la_ldh"

# Create a temporary directory for testing
test_dir <- withr::local_tempdir()
print(paste("Testing in:", test_dir))

# Test 1: Fetch data from API (or use cached)
cat("\n=== Testing get_mixpanel_data ===\n")
df_test <- get_mixpanel_data(
  from_date = FROM_DATE,
  to_date = TO_DATE,
  client_agency = CLIENT_AGENCY,
  cache_dir = test_dir,
)

df <- sample_mixpanel(df_test)

file <- "../../../Downloads/sample_mp_data.json"
cache_mixpanel(df, file)
# rm(df, df_test)
df <- load_cached_mixpanel(file)

list.files(test_dir)

jsonlite::read_json(file) %>% tibble::as_tibble()

jsonlite::stream_in(file(file)) %>% tibble::as_tibble()


read_mixpanel(file, 
              device_type = properties$device_type,
              origin = properties$origin,
              drop_prop = TRUE) %>% 
  dplyr::glimpse()
