resource "google_secret_manager_secret" "md-svc-token" {
  secret_id = "md-svc-token"
  project  = var.var_gcp_project_id

  replication {
    auto{}
  }

  depends_on = [google_project_service.secretmanager]
}

resource "google_secret_manager_secret_version" "md-svc-token-v-1" {
  secret      = google_secret_manager_secret.md-svc-token.id
  secret_data = var.var_md_svc_token
}