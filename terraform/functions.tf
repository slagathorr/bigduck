data "archive_file" "source" {
    type        = "zip"
    source_dir  = "../src"
    output_path = "./tmp/function.zip"
}

resource "google_storage_bucket_object" "zip" {
    source       = data.archive_file.source.output_path
    content_type = "application/zip"

    # Append to the MD5 checksum of the files's content
    # to force the zip to be updated as soon as a change occurs
    name         = "src-${data.archive_file.source.output_md5}.zip"
    bucket       = google_storage_bucket.function-bucket.name
}

resource "google_cloudfunctions2_function" "gcf-md-query" {
  name        = "md-query"
  location    = var.var_region
  description = "Query MotherDuck: cvdb.vulns"
  project     = var.var_gcp_project_id

  build_config {
    runtime     = "python311"
    entry_point = "md_get_vc" # Set the entry point
    source {
      storage_source {
        bucket = google_storage_bucket.function-bucket.name
        object = google_storage_bucket_object.zip.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "512M"
    timeout_seconds    = 60
    service_account_email = google_service_account.sa-cloudrun-md.email

    secret_environment_variables {
      key     = "md-svc-token"
      project_id = var.var_gcp_project_id
      secret  = google_secret_manager_secret.md-svc-token.secret_id
      version = "latest"
    }
  }

  depends_on = [google_secret_manager_secret_iam_binding.md-token-secret-iam-binding]
}