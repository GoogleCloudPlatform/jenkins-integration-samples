#!/bin/bash

# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file contains environment variables to be configured for
# installation of Jenkins X. Replace each value "[FILL_ME_IN]" with an appropriate
# configuration value.

## GCP vars

# The ID of the GCP project to be installed into.
export PROJECT_ID="[FILL_ME_IN]"

# The name of the GCP SA to be used during installation.
export SA_NAME="[FILL_ME_IN]"

## Terraform vars

# The path to the GCP SA JSON key to be used by Terraform.
export GOOGLE_CLOUD_KEYFILE_JSON="[FILL_ME_IN]"

# The local file path for the TF plan file.
export TF_PLAN_FILE="[FILL_ME_IN]"

# The GCP region for the project.
export TF_VAR_gcp_region="[FILL_ME_IN]"

# The name of the managed address to be created for the cluster's
# ingress.
export TF_VAR_cluster_address_name="[FILL_ME_IN]"

# The name of the GKE cluster to be created.
export TF_VAR_cluster_name="[FILL_ME_IN]"

# The hostname for the GKE cluster's ingress.
export TF_VAR_cluster_hostname="[FILL_ME_IN]"

# The domain to be used bythe Jenkins X installation
export JX_DOMAIN="[FILL_ME_IN]"

# The subdomain to be used by the Jenkins X installation
export JX_SUBDOMAIN="[FILL_ME_IN]"

# The DNS name for GKE cluster's ingress record sets.
export TF_VAR_cloud_dns_name="[FILL_ME_IN]"

# The name of the cloud DNS managed zone to be created for the GKE
# cluster's ingress record sets.
export TF_VAR_cloud_dns_managed_zone_name="[FILL_ME_IN]"

# The zone the cluster will be created in.
export TF_VAR_cluster_zone="[FILL_ME_IN]"

# The name of the GCS bucket to be created for log storage.
export TF_VAR_log_storage_bucket="[FILL_ME_IN]"

# The name of the DNS service account to be created.
export TF_VAR_cloud_dns_sa_name="[FILL_ME_IN]"

# The name of the GitHub Organization the Jenkins X environment
# repositories will be created under.
export GITHUB_ORG="[FILL_ME_IN]"

# The email address to be used to LetsEncrypt
export CERT_EMAIL="[FILL_ME_IN]"

export TF_VAR_gcp_project="${PROJECT_ID}"

# Configure gcloud to target the configured project.
gcloud config set project $PROJECT_ID
