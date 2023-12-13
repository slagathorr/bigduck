 ## This creates a cloud resource connection.
 ## Note: The cloud resource nested object has only one output only field - serviceAccountId.
 resource "google_bigquery_connection" "rc-gcf" {
    connection_id = "rc-gcf"
    project = var.var_gcp_project_id
    location = "US"
    description = "Remote connection for Cloud Run v2 functions."
    cloud_resource {}
}

resource "google_bigquery_dataset" "function_library" {
  dataset_id                 = "function_library_${random_id.instance_id.hex}"
  location                   = "US"
  project                    = var.var_gcp_project_id
}