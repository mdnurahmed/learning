//create a bucket
resource "google_storage_bucket" "nur-bucket" {
  name          = "kittennurahmedsabbir"
  location      = "EU"
  force_destroy = true
}

//upload a object into the bucket
resource "google_storage_bucket_object" "picture" {
  name   = "kittennurahmedsabbir"
  bucket = "kittennurahmedsabbir"
  source = "kitten.jpg"
  depends_on = [
    google_storage_bucket.nur-bucket
  ]
}




//initally add permission to the node-pool/kubernetes service account
resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.nur-bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.kubernetes.email}"
  depends_on = [
    google_service_account.kubernetes
  ]
}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam







//create a service account that has access to the bucket
resource "google_service_account" "service-a" {
  account_id   = "nur-worload-identity-test"
  display_name = "nur-worload-identity-test"
  description  = "nur-worload-identity-test"
  depends_on = [
    google_storage_bucket.nur-bucket
  ]
}

//add permission to the service account
resource "google_storage_bucket_iam_member" "anothermember" {
  bucket = google_storage_bucket.nur-bucket.name
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.service-a.email}"
  depends_on = [
    google_service_account.service-a
  ]
}

//add mapping
# # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
# resource "google_service_account_iam_member" "service-a" {
#   service_account_id = google_service_account.service-a.id
#   role               = "roles/iam.workloadIdentityUser"
#   member             = "serviceAccount:methodical-bee-198709.svc.id.goog[default/myserviceaccount]"
# }