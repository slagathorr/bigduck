resource "google_secret_manager_secret" "md-svc-token" {
  secret_id = "md-svc-token"
  project  = var.var_gcp_project_id
  
  replication {
    auto{}
  }

  depends_on = [google_project_service.secretmanager]
}