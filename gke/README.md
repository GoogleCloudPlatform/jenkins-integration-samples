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

# GKE Sample Project

This is an example project illustrating best practices for running Jenkins on GCP leveraging integrations published and officially supported by [GCP](https://cloud.google.com/). It highlights running [Jenkins](https://jenkins.io/) running in [GKE](https://cloud.google.com/kubernetes-engine/) using the [Kubernetes Plugin](https://github.com/jenkinsci/kubernetes-plugin) and utilizing a suite of GCP officially supported Jenkins plugins: ([GCS](https://github.com/jenkinsci/google-storage-plugin), [OAuth](https://github.com/jenkinsci/google-oauth-plugin), [GKE](https://github.com/jenkinsci/google-kubernetes-engine-plugin)) It demonstrates a real world use-case by building and testing a SpringBoot web application, building a container using Kaniko, publishing that container to GCR, and finally deploying the application to both staging and production environments in GKE.


This project demonstrates the following:

* Jenkins running in GKE using the [Kubernetes Plugin](https://github.com/jenkinsci/kubernetes-plugin)

* Utilizing GCP officially supported Jenkins plugins: ([GCS](https://github.com/jenkinsci/google-storage-plugin), [OAuth](https://github.com/jenkinsci/google-oauth-plugin), [GKE](https://github.com/jenkinsci/google-kubernetes-engine-plugin))

* Demonstrates best practices with real world use-case
  * Builds and tests [SpringBoot](https://spring.io/guides/gs/spring-boot/) Application
  * Publishes container image to [GCR](https://cloud.google.com/container-registry/) using [Kaniko](https://github.com/GoogleContainerTools/kaniko)
  * Uses the [Jenkins GKE]((https://github.com/jenkinsci/google-kubernetes-engine-plugin)) plugin to deploy to multiple clusters in [GKE](https://cloud.google.com/kubernetes-engine/)


# Setup steps
The following describes the setup process for this project.

1. Install Jenkins on GKE using the stable/jenkins helm chart: [Jenkins On GKE Tutorial](https://cloud.google.com/solutions/jenkins-on-kubernetes-engine-tutorial)

1. Install and configure the GKE plugin: [Jenkins GKE Docs](https://github.com/jenkinsci/google-kubernetes-engine-plugin/blob/develop/docs/Home.md)

1. Add GCP SA JSON key to secret store for kaniko:
`kubectl create secret generic kaniko-secret --from-file=<path to kaniko-secret.json>`

1. Create a new Multibranch Pipeline Jenkins project pointed at this repository: [Jenkins Multibranch Pipeline Tutorial](https://jenkins.io/doc/tutorials/build-a-multibranch-pipeline-project/)

