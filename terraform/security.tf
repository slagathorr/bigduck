resource "google_project_iam_binding" "sa-rc-gcf-run-invoker-iam-binding" {
  project = var.var_gcp_project_id
  role    = "roles/run.invoker"

  members = [
    "serviceAccount:${google_bigquery_connection.rc-gcf.cloud_resource[0].service_account_id}"
  ]
}

resource "google_service_account" "sa-cloudrun-md" {
  account_id = "sa-md-cloudrun"
  project = var.var_gcp_project_id
}

resource "google_secret_manager_secret_iam_binding" "md-token-secret-iam-binding" {
  project = var.var_gcp_project_id
  secret_id = google_secret_manager_secret.md-svc-token.secret_id
  role    = "roles/secretmanager.secretAccessor"
  members = ["serviceAccount:${google_service_account.sa-cloudrun-md.email}"]
}