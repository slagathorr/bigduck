resource "google_project_iam_binding" "sa-rc-gcf-run-invoker-iam-binding" {
  project = var.var_gcp_project_id
  role    = "roles/run.invoker"

  members = [
    "serviceAccount:${google_bigquery_connection.rc-gcf.cloud_resource[0].service_account_id}"
  ]
}