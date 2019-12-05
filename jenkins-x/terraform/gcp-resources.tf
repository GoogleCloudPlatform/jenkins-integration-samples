/*
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "log_storage_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_zone" {
  type = string
}

variable "cluster_hostname" {
  type = string
}

variable "cloud_dns_name" {
  type = string
}

variable "cloud_dns_managed_zone_name" {
  type = string
}

variable "cloud_dns_sa_name" {
  type = string
}

resource "google_dns_managed_zone" "cluster-dns" {
  provider   = "google-beta"
  visibility = "public"
  dns_name   = var.cloud_dns_name
  name       = var.cloud_dns_managed_zone_name
}

resource "google_container_cluster" "jenkins-x-cluster" {
  name                     = var.cluster_name
  network                  = "default"
  location                 = var.cluster_zone
  remove_default_node_pool = true
  initial_node_count = 1
}

resource "google_container_node_pool" "jenkins-x-cluster-pool" {
  name     = "${var.cluster_name}-pool"
  location = var.cluster_zone
  cluster  = "${google_container_cluster.jenkins-x-cluster.name}"

  node_config {
    machine_type = "n1-standard-4"
    disk_size_gb = 240
    disk_type    = "pd-ssd"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 10
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

resource "google_storage_bucket" "bucket" {
  name = var.log_storage_bucket
}

resource "google_service_account" "dns-admin-sa" {
  account_id   = var.cloud_dns_sa_name
  display_name = var.cloud_dns_sa_name
}

resource "google_service_account_iam_binding" "service-account-role" {
  service_account_id = google_service_account.dns-admin-sa.name
  role               = "roles/iam.serviceAccountUser"
  members = [
    "serviceAccount:${google_service_account.dns-admin-sa.email}",
  ]
}


/* TODO(#14): Add support for managed addresses.

variable "cluster_address_name" {
  type = string
}

resource "google_compute_global_address" "cluster-address" {
  name         = var.cluster_address_name
  address_type = "EXTERNAL"
}


resource "google_dns_record_set" "cluster-a-record" {
  name         = "${var.cluster_hostname}."
  managed_zone = "${google_dns_managed_zone.cluster-dns.name}"
  type         = "A"
  ttl          = 300

  rrdatas = ["${google_compute_global_address.cluster-address.address}"]
}

resource "google_dns_record_set" "cluster-cname-record" {
  name         = "www.${var.cluster_hostname}."
  managed_zone = "${google_dns_managed_zone.cluster-dns.name}"
  type         = "CNAME"
  ttl          = 300

  rrdatas = ["${var.cluster_hostname}."]
}
*/
