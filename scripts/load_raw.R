
# Load packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load("bigrquery", "readr", "readxl", "dplyr", "here")

# Configuration
project_id <- "bank-customer-analytics"
dataset    <- "raw"

# Authenticate
bq_auth(path = here("bank-customer-analytics-1da91a028325.json"))

# Helper function to upload a dataframe to BigQuery
upload_table <- function(df, table_name) {
  message("Uploading: ", table_name)
  bq_table_upload(
    bq_table(project_id, dataset, table_name),
    df,
    create_disposition = "CREATE_IF_NEEDED",
    write_disposition  = "WRITE_TRUNCATE"
  )
  message("Done: ", table_name)
}

# Load and upload CSV files
upload_table(read_csv(here("data/raw/Bank_Churn.csv")),  "bank_churn")
upload_table(read_csv(here("data/raw/CustomerInfo.csv")),  "customer_info")

# Load and upload XLSX files
upload_table(read_xlsx(here("data/raw/ActiveCustomer.xlsx")), "active_customer")
upload_table(read_xlsx(here("data/raw/CreditCard.xlsx")), "credit_card")
upload_table(read_xlsx(here("data/raw/ExitCustomer.xlsx")), "exit_customer")
upload_table(read_xlsx(here("data/raw/Gender.xlsx")), "gender")
upload_table(read_xlsx(here("data/raw/Geography.xlsx")), "geography")

message("All tables loaded successfully.")

