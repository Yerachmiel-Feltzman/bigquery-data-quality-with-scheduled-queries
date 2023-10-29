variable "gcp_project" {
  type = string
}

variable "gcp_region" {
  type = string
  default = "us-central1"
}

variable "data_quality_check_name" {
  type    = string
  default = "natality table has out-of-bounds birth years"
}


