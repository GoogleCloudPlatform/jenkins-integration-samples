<!--
 Copyright 2019 Google LLC

 Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in
 compliance with the License. You may obtain a copy of the License at

        https://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed under the License
 is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 implied. See the License for the specific language governing permissions and limitations under the
 License.
-->

# Jenkins Integrations

This repository houses example projects illustrating best practices for running [Jenkins](https://jenkins.io/) leveraging the integrations published and officially supported by [GCP](https://cloud.google.com/).

## GCP Officially Supported Plugins

*  [GCE](https://github.com/jenkinsci/google-compute-engine-plugin)

The Google Compute Engine (GCE) Plugin allows you to use GCE virtual machines (VMs) with Jenkins to execute build tasks. GCE VMs provision quickly, are destroyed by Jenkins when idle, and offer Preemptible VMs that run at a much lower price than regular VMs.

*  [GKE](https://github.com/jenkinsci/google-kubernetes-engine-plugin)

The Google Kubernetes Engine (GKE) Plugin allows you to deploy build artifacts to Kubernetes clusters running in GKE with Jenkins.

*  [OAuth](https://github.com/jenkinsci/google-oauth-plugin)

This plugin implements the OAuth Credentials interfaces to surface Google Service Account credentials to Jenkins.

*  [GCS](https://github.com/jenkinsci/google-storage-plugin)

This plugin provides the “Google Cloud Storage Uploader” post-build step for publishing build artifacts to Google Cloud Storage.

## Sample Projects

*  [GKE](https://github.com/GoogleCloudPlatform/jenkins-integration-samples/tree/master/gke)
    
An example project illustrating best practices for running Jenkins on GCP, highlighting running Jenkins running in [GKE](https://cloud.google.com/kubernetes-engine/) using the [Kubernetes Plugin](https://github.com/jenkinsci/kubernetes-plugin) and utilizing a suite of GCP officially supported Jenkins plugins: ([GCS](https://github.com/jenkinsci/google-storage-plugin), [OAuth](https://github.com/jenkinsci/google-oauth-plugin), [GKE](https://github.com/jenkinsci/google-kubernetes-engine-plugin)).

## Playbooks

*  [Jenkins X](https://github.com/GoogleCloudPlatform/jenkins-integration-samples/tree/master/jenkins-x)

A playbook for installing [Jenkins X](https://jenkins-x.io/), (aka **jx**), on [GCP](https://cloud.google.com/)
using recommended best practices.
