resource "google_project_service" "secretmanager" {
  project  = var.var_gcp_project_id
  service  = "secretmanager.googleapis.com"
}

resource "google_project_service" "cloudfunctions" {
  project  = var.var_gcp_project_id
  service  = "cloudfunctions.googleapis.com"
}

resource "google_project_service" "bqc" {
  project  = var.var_gcp_project_id
  service  = "bigqueryconnection.googleapis.com"
}

resource "google_project_service" "run" {
  project  = var.var_gcp_project_id
  service  = "run.googleapis.com"
}

resource "google_project_service" "build" {
  project  = var.var_gcp_project_id
  service  = "cloudbuild.googleapis.com"
}