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
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  metadata = {
    user-data = templatefile("cloud-init.yml", { version = "v4.38-9760-rtm", date = "2021.08.17" })
  }

  network_interface {
    network = "default"

    access_config {
     // Include this section to give the VM an external ip address
    }
  }
}

resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"
  network = "default"
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }
}
