resource "google_project_service" "secretmanager" {
  project  = var.var_gcp_project_id
  service  = "secretmanager.googleapis.com"
}