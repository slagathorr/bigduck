resource "google_storage_bucket" "function-bucket" {
    name     = "${var.var_gcp_project_id}-function-${random_id.instance_id.hex}"
    location = var.var_region
    project  = var.var_gcp_project_id
    uniform_bucket_level_access = true
}