variable "var_gcp_project_id" {
    description = "Google Cloud project ID"
    type        = string
}

variable "var_md_svc_token" {
    description = "MotherDuck Service Token"
    type        = string
}

variable "var_region"{
    description = "Default region"
    default = "us-central1"
}

variable "var_sa_rc_gcf_id"{
    description = "Service Account name that will invoke Cloud Functions from BigQuery"
    default = "sa-bq-rc-gcf"
}