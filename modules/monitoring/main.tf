resource "google_monitoring_dashboard" "dashboard" {
  dashboard_json = jsonencode({
    displayName = "LLM Dashboard Monitoring"
    gridLayout = {
      columns = "2"
      widgets = [
        {
          title   = "Cloud Run Request Count"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "metric.type=\"run.googleapis.com/request_count\" resource.type=\"cloud_run_revision\""
                }
              }
            }]
          }
        },
        {
          title   = "Cloud SQL CPU Usage"
          xyChart = {
            dataSets = [{
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" resource.type=\"cloudsql_database\""
                }
              }
            }]
          }
        }
      ]
    }
  })
}

resource "google_logging_project_sink" "log_sink" {
  name        = "${var.project_id}-log-sink"
  destination = "storage.googleapis.com/${google_storage_bucket.log_bucket.name}"
  filter      = "resource.type = (\"cloud_run_revision\" OR \"cloudsql_database\")"

  unique_writer_identity = true
}

resource "google_storage_bucket" "log_bucket" {
  name     = "${var.project_id}-logs"
  location = var.region
}