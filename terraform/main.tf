resource "random_id" "instance_id" {
 byte_length = 8
}

# Output of SQL command to create function.
output "function_url" {
  value = <<EOT
    # RUN THIS IN BIGQUERY

    CREATE OR REPLACE FUNCTION
    `${var.var_gcp_project_id}`.function_library.md_vulns(service_name STRING)
    RETURNS INT64
    REMOTE WITH CONNECTION `${google_bigquery_connection.rc-gcf.project}.${google_bigquery_connection.rc-gcf.location}.${google_bigquery_connection.rc-gcf.connection_id}`
    OPTIONS(
            endpoint = '${google_cloudfunctions2_function.gcf-md-query.url}'
    )
    
  EOT
}