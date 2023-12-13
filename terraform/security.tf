resource "google_service_account" "sa-rc-gcf" {
  account_id   = var.var_sa_rc_gcf_id
  display_name = "sa - Steampipe Viewer Service"
  project = var.var_gcp_project_id
}

resource "google_project_iam_binding" "sa-rc-gcf-run-invoker-iam-binding" {
  project = var.var_gcp_project_id
  role    = "roles/run.invoker"

  members = [
    google_service_account.sa-rc-gcf.member
  ]
}