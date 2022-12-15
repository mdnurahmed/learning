

provider "google" {
  project = "methodical-bee-198709"
  region  = "us-central1"
}


resource "google_storage_bucket" "static-site" {
  name          = "butterflynurahmedsabbir"
  location      = "EU"
  force_destroy = true
}

resource "google_storage_bucket_object" "picture" {
  name   = "butterflynurahmedsabbir"
  bucket = "butterflynurahmedsabbir"
  source = "kitten.jpg"
  depends_on = [
    google_storage_bucket.static-site
  ]
}