locals {
  project_id = "expressapitest"
}

provider "google" {
  credentials = file("/Users/aurelienbettini/.config/gcloud/application_default_credentials.json")
  project     = local.project_id
  region     = "us-east4"
}

resource "google_project_service" "firestore" {
  project = local.project_id
  service = "firestore.googleapis.com"
}

# # IF YOU WANT TO CREATE A FIRESTORE DATABASE
resource "google_firestore_database" "database" {
  project     = local.project_id
  name        = "(default)"
  location_id = "us-east4"
  type        = "FIRESTORE_NATIVE"

  depends_on = [google_project_service.firestore]
}

# Newsletter Subscription
resource "google_firestore_index" "newsletter-subscription-index" {
  project = local.project_id
  collection = "newsletter-subscription"
  
  fields {
    field_path = "email"
    order = "ASCENDING"
  }

  fields {
    field_path = "status"
    order = "ASCENDING"
  }
}
