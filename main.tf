terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = "ram-pde-project"
  region  = "europe-west2"
  zone    = "europe-west2-a"
}

resource "google_service_account" "terraform_service_account" {
  account_id   = "terraform-svc-account"
  display_name = "Service Account used for terraform"
}

resource "google_project_iam_binding" "terraform_bigquery_writer" {
  role = "roles/bigquery.dataEditor"

  members = [
   "serviceAccount:${google_service_account.terraform_service_account.email}",
  ]
}

resource "google_project_iam_binding" "terraform_gcs_reader" {
  role = "roles/storage.objectViewer"
  
  members = [
   "serviceAccount:${google_service_account.terraform_service_account.email}",
  ]
}

resource "google_compute_network" "terraform_vpc" {
  name = "terraform-vpc"
}

data "template_file" "startup-script-custom" {
  template = file("${path.module}/templates/startup-script-custom.tpl")
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
      #image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = google_compute_network.terraform_vpc.name
    access_config {
    }
  }

  metadata = {
    startup-script-custom = data.template_file.startup-script-custom.rendered
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.terraform_service_account.email
    scopes = ["cloud-platform"]
  }

  # We connect to our instance via Terraform and remotely executes our script using SSH
  #provisioner "remote-exec" {
  #  script = "startup_script.sh"

  #  connection {
  #    type  = "ssh"
  #    host  = google_compute_address.static.address
  #    user  = google_service_account.terraform_service_account.email
  #  }
  # }

}

# We create a public IP address for our google compute instance to utilize
resource "google_compute_address" "static" {
  name = "vm-public-address"
}
