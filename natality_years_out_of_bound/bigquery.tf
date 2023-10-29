locals {
  error_msg = "FOUND BAD RECORDS for data quality check ${var.data_quality_check_name}"

  query = templatefile(
    "${path.module}/natality_table_years_bound_check.sql",
    { found_bad_records = local.error_msg }
  )
}

resource "google_bigquery_data_transfer_config" "scheduled_query" {
#  service_account_name = var.service_account

  display_name   = title(var.data_quality_check_name)
  data_source_id = "scheduled_query"
  disabled       = false
  params         = {
    query = local.query
  }
}


