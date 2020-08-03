variable project {
  type = string
}

variable region {
  type = string
}

variable zone {
  type = string
}

terraform {
  backend "gcs" {}
}

provider "google" {
  region = var.region
}

data "google_project" "project" {
  project_id = var.project
}

#add cloud build roles for windows-builder
locals {
  build_sa_roles = [
    "roles/compute.admin",
    "roles/iam.serviceAccountUser"
  ]
}

resource "google_project_iam_member" "build_sa_roles" {
  count = length(local.build_sa_roles)
  role = local.build_sa_roles[count.index]
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}