resource "google_project_iam_custom_role" "minimal_cloud_run_role" {
  role_id     = var.custom_role_id
  title       = "Minimal Cloud Run Invoker"
  description = "A minimal role for invoking Cloud Run services"
  permissions = [
    "run.routes.invoke",
    "run.services.get",
  ]
}

resource "google_project_iam_member" "cloud_run_invoker" {
  project = var.project_id
  role    = google_project_iam_custom_role.minimal_cloud_run_role.id
  member  = "serviceAccount:${var.service_account_email}"
}

resource "google_compute_security_policy" "security_policy" {
  name = "${var.project_id}-security-policy"

  rule {
    action   = "allow"
    priority = "1000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = var.allowed_ip_ranges
      }
    }
    description = "Allow access from specified IP ranges"
  }

  rule {
    action   = "deny(403)"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Deny all other traffic"
  }
}