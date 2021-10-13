terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.88.0"
    }
  }
}

provider "google" {
  credentials = file("CREDENTIALS.json")
  project     = "vpn-server-318803"
  region      = "us-west1"
}

resource "random_id" "instance_id" {
  byte_length = 8
}

resource "google_compute_instance" "default" {
  name         = "vpn-server-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential"

  network_interface {
    network = "default"

    access_config {
     // Include this section to give the VM an external ip address
    }
  }
}
