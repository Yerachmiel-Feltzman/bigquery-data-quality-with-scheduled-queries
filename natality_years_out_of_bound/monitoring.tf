data "google_monitoring_notification_channel" "email_yerachmiel" {
  display_name = "Email: Yerachmiel Feltzman"
}

resource "google_monitoring_alert_policy" "found_bad_records" {
  enabled      = true
  display_name = "BigQuery Data Quality Check - ${title(var.data_quality_check_name)}"

  documentation {
    content   = "Records were found in BigQuery given the query\n```\n${local.query}\n```"
    mime_type = "text/markdown"
  }

  notification_channels = [
    data.google_monitoring_notification_channel.email_yerachmiel.name,
  ]
  alert_strategy {
    # 1 hour
    notification_rate_limit { period = "${1*60*60}s" }
  }

  combiner = "OR"
  conditions {
    display_name = "caught the custom raised error message from the scheduled query"
    condition_matched_log {
      filter = <<EOF
        resource.type="bigquery_resource"
        protoPayload.serviceData.jobCompletedEvent.job.jobStatus.error.message=~"${local.error_msg}"
        protoPayload.serviceData.jobCompletedEvent.job.jobConfiguration.labels.data_source_id="${google_bigquery_data_transfer_config.scheduled_query.data_source_id}"
      EOF
    }
  }

}

resource "google_monitoring_alert_policy" "scheduled_query_failed" {
  enabled      = true
  display_name = "BigQuery Data Quality Check - Scheduled Query ${google_bigquery_data_transfer_config.scheduled_query.display_name} failed to run."

  documentation {
    content   = "The scheduled query has failed to run, which means we cannot be be notified if the data quality checks finds something."
    mime_type = "text/markdown"
  }

  notification_channels = [
    data.google_monitoring_notification_channel.email_yerachmiel.name,
  ]
  alert_strategy {
    # 1 hour
    notification_rate_limit { period = "${1*60*60}s" }
  }

  combiner = "OR"
  conditions {
    display_name = "caught some error when running the scheduled query"
    condition_matched_log {
      filter = <<EOF
resource.type=bigquery_dts_config
resource.labels.config_id="${element(split("/", google_bigquery_data_transfer_config.scheduled_query.id),
                            length(split("/", google_bigquery_data_transfer_config.scheduled_query.id)) - 1)}"
logName="projects/${data.google_project.current.name}/logs/bigquerydatatransfer.googleapis.com%2Ftransfer_config"
severity>=ERROR
-jsonPayload.message=~"${local.error_msg}"
EOF
    }
  }

}


