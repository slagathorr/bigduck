resource "random_id" "instance_id" {
 byte_length = 8
}

# Output of SQL command to create function.
output "function_url" {
  value = <<EOT

    ----------------------------------------------------------------

    # RUN THIS IN BIGQUERY TO CREATE THE REMOTE FUNCTION

    CREATE OR REPLACE FUNCTION
    `${var.var_gcp_project_id}`.${google_bigquery_dataset.function_library.dataset_id}.md_vulns(service_name STRING)
    RETURNS INT64
    REMOTE WITH CONNECTION `${google_bigquery_connection.rc-gcf.project}.${google_bigquery_connection.rc-gcf.location}.${google_bigquery_connection.rc-gcf.connection_id}`
    OPTIONS(
            endpoint = '${google_cloudfunctions2_function.gcf-md-query.url}'
    );

    ----------------------------------------------------------------

    # RUN THIS QUERY TO TEST IT WORKS

    WITH
        input_data AS (
            SELECT "AAD" input 
            UNION ALL SELECT "Cloud SQL" input
            UNION ALL SELECT "Cloud SQL" input
            UNION ALL SELECT "AAD" input
            UNION ALL SELECT "EC2" input
            UNION ALL SELECT "Cloud Shell" input
        )
    SELECT
        input, ${google_bigquery_dataset.function_library.dataset_id}.md_vulns(input)
    FROM
        input_data;
    
    ----------------------------------------------------------------

  EOT
}