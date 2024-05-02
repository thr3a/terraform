locals {
  name         = "deep01"
  machine_type = "a2-highgpu-1g"
  region       = "asia-northeast1"
  zone         = "asia-northeast1-a"
  gpu          = "nvidia-tesla-a100"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "terraform.turai.work"
    region = "ap-northeast-1"
    # profile = "terraform"
    key = "aws/deep/terraform.tfstate"
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

resource "google_compute_address" "deep01" {
  provider     = google.tokyo
  name         = local.name
  network_tier = "STANDARD"
}

resource "google_compute_disk" "deep01" {
  provider = google.tokyo
  image    = "ubuntu-os-cloud/ubuntu-2204-lts"
  name     = local.name
  size     = 200
  type     = "pd-standard"
  zone     = local.zone
  # snapshot = "xxx"
}

resource "google_compute_instance" "deep01" {
  provider     = google.tokyo
  name         = local.name
  machine_type = local.machine_type
  zone         = local.zone

  guest_accelerator {
    type  = local.gpu
    count = 1
  }

  boot_disk {
    source      = google_compute_disk.deep01.name
    auto_delete = false
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip       = google_compute_address.deep01.address
      network_tier = "STANDARD"
    }
  }
  allow_stopping_for_update = true

  scheduling {
    on_host_maintenance = "TERMINATE" # GPUの場合必須
    automatic_restart   = false
    preemptible         = true
    provisioning_model  = "SPOT"
  }
}
