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
    default = "us-central1-a"
}