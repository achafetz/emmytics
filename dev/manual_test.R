# Load your package in development mode
devtools::load_all()

# Set up test parameters
FROM_DATE <- "2026-02-19"
# TO_DATE <- "2025-12-01‚"
TO_DATE <- "2026-02-25"
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

print(paste("Loaded", nrow(df), "events"))
print(head(df))

# Test 2: Filter by client agency
cat("\n=== Testing filter_by_client_agency ===\n")
filtered_df <- filter_by_client_agency(df, CLIENT_AGENCY)
print(paste("Filtered to", nrow(filtered_df), CLIENT_AGENCY, "events"))

# Test 3: Verify cached file exists
cat("\n=== Checking cached files ===\n")
list.files(test_dir, pattern = "mixpanel_data")

# Test 4: Load from cache
cat("\n=== Testing load from cache ===\n")
cached_df <- get_mixpanel_data(
  from_date = FROM_DATE,
  to_date = TO_DATE,
  force_reload = FALSE,
  cache_dir = test_dir
)

print(paste("Loaded from cache:", nrow(cached_df), "events"))

# Test 5: Compare formats
cat("\n=== Testing JSON format ===\n")
cache_mixpanel(df, file.path(test_dir, "test_json"), format = "json")
cache_mixpanel(df, file.path(test_dir, "test_parquet"), format = "parquet")

json_size <- file.info(file.path(test_dir, "test_json.json"))$size / 1024^2
parquet_size <- file.info(file.path(test_dir, "test_parquet.parquet"))$size / 1024^2

cat(sprintf("JSON size: %.2f MB\n", json_size))
cat(sprintf("Parquet size: %.2f MB\n", parquet_size))
cat(sprintf("Compression ratio: %.1f%%\n", (1 - parquet_size/json_size) * 100))

# Cleanup
cat("\n=== Cleanup ===\n")
unlink(test_dir, recursive = TRUE)
cat("Test complete!\n")