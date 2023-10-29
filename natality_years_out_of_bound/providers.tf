terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.1.0"
    }
  }
  required_version = ">= 1.6.1"
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

data "google_project" "current" {}
