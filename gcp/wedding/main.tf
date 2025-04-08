locals {
  name         = "wed01"
  machine_type = "e2-standard-4"
  region       = "asia-northeast1"
  zone         = "asia-northeast1-a"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "terraform.turai.work"
    region = "ap-northeast-1"
    # profile = "terraform"
    key = "gcp/wedding/terraform.tfstate"
  }
}

provider "google" {
  project     = "amanekey"
  region      = local.region
  zone        = local.zone
  credentials = "/Users/thr3a/.config/gcloud/application_default_credentials.json"
}

provider "google" {
  project     = "amanekey"
  region      = local.region
  zone        = local.zone
  credentials = "/Users/thr3a/.config/gcloud/application_default_credentials.json"
  alias       = "tokyo"
}

resource "google_compute_address" "main" {
  provider     = google.tokyo
  name         = local.name
  network_tier = "STANDARD"
}

resource "google_compute_disk" "main" {
  provider = google.tokyo
  image    = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2404-lts-amd64"
  name     = local.name
  size     = 50
  type     = "pd-standard"
  zone     = local.zone
  # snapshot = "xxx"
}

resource "google_compute_instance" "main" {
  provider     = google.tokyo
  name         = local.name
  machine_type = local.machine_type
  zone         = local.zone

  boot_disk {
    source      = google_compute_disk.main.id
    auto_delete = true
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip       = google_compute_address.main.address
      network_tier = "STANDARD"
    }
  }
  allow_stopping_for_update = true

  scheduling {
    # on_host_maintenance = "TERMINATE" # GPUの場合必須
    automatic_restart   = false
    # preemptible         = true
    # provisioning_model  = "SPOT"
  }

  metadata = {
    user-data = file("../cloud-config.yml"),
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }
}

# resource "google_compute_disk" "sub" {
#   provider = google.tokyo
#   name     = format("%s-%s", local.name, "sub")
#   size     = 80
#   type     = "pd-standard"
#   zone     = local.zone
#   # snapshot = "xxx"
# }

# resource "google_compute_attached_disk" "default" {
#   disk     = google_compute_disk.main.id
#   instance = google_compute_instance.main.id
# }
