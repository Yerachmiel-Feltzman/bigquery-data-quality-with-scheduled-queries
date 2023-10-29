terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.1.0"
    }
  }
  required_version = ">= 1.6.1"
}

data "google_project" "current" {}
