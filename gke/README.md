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

This is an example project illustrating best practices for running Jenkins on GCP leveraging
integrations published and officially supported by [GCP](https://cloud.google.com/). It highlights
running [Jenkins](https://jenkins.io/) running in [GKE](https://cloud.google.com/kubernetes-engine/)
using the [Kubernetes Plugin](https://github.com/jenkinsci/kubernetes-plugin) and utilizing a suite
of GCP officially supported Jenkins plugins: 
([GCS](https://github.com/jenkinsci/google-storage-plugin),
[OAuth](https://github.com/jenkinsci/google-oauth-plugin),
[GKE](https://github.com/jenkinsci/google-kubernetes-engine-plugin)). It demonstrates a real world
use-case by building and testing a SpringBoot web application, building a container using Kaniko,
publishing that container to GCR, and finally deploying the application to both staging and
production environments in GKE.


This project demonstrates the following:

* Jenkins running in GKE using the
  [Kubernetes Plugin](https://github.com/jenkinsci/kubernetes-plugin).

* Utilizing GCP officially supported Jenkins plugins:
  ([GCS](https://github.com/jenkinsci/google-storage-plugin),
  [OAuth](https://github.com/jenkinsci/google-oauth-plugin),
  [GKE](https://github.com/jenkinsci/google-kubernetes-engine-plugin)).

* Demonstrates best practices with real world use-case:
  * Builds and tests [SpringBoot](https://spring.io/guides/gs/spring-boot/) Application.
  * Publishes container image to [GCR](https://cloud.google.com/container-registry/) using
    [Kaniko](https://github.com/GoogleContainerTools/kaniko).
  * Uses the [Jenkins GKE]((https://github.com/jenkinsci/google-kubernetes-engine-plugin)) plugin to
    deploy to multiple clusters in [GKE](https://cloud.google.com/kubernetes-engine/).


# Setup steps
The following describes the setup process for this project:

1. Install Jenkins on GKE using the stable/jenkins helm chart: [Jenkins On GKE Tutorial](
   https://cloud.google.com/solutions/jenkins-on-kubernetes-engine-tutorial).

1. Install and configure the following plugins:
   1. GKE plugin: [Jenkins GKE Docs](https://github.com/jenkinsci/google-kubernetes-engine-plugin/blob/develop/docs/Home.md).
   1. GCS plugin: [Jenkins GCS Docs](https://github.com/jenkinsci/google-storage-plugin/blob/develop/README.md).
   1. OAuth plugin: [Jenkins OAuth Docs](https://github.com/jenkinsci/google-oauth-plugin/blob/develop/README.md).

1. Create a GCS bucket to upload your test work, e.g. 'projectname-jenkins-test-bucket'

1. Create GCP service account that can push objects to your bucket and containers to your registry:
   ```bash
    export PROJECT=YOURGOOGLEPROJECTNAME
    export SA=kaniko-role
    gcloud iam service-accounts create $SA
    export SA_EMAIL=$SA@$PROJECT.iam.gserviceaccount.com
    gcloud projects add-iam-policy-binding $PROJECT \
    --member serviceAccount:$SA_EMAIL \
    --role 'roles/containeranalysis.admin'
    gcloud projects add-iam-policy-binding $PROJECT \
    --member serviceAccount:$SA_EMAIL \
    --role 'roles/storage.objectAdmin'
    gcloud iam service-accounts keys create ./kaniko-secret.json --iam-account $SA_EMAIL
    ```

1. Add the environment variables `JENKINS_TEST_PROJECT_ID`, `JENKINS_TEST_CRED_ID` and
   `JENKINS_TEST_BUCKET` to the Jenkins master configuration.
   1. Go to **Manage Jenkins** > **Configure System**.
   1. Then under **Global Properties** check "Environment variables".
   1. Add each environment variable as a key-value pair.

1. Add GCP SA JSON key to secret store for kaniko:
    ```bash
    kubectl create secret generic kaniko-secret --from-file=./kaniko-secret.json
    ```

1. Create a new Multibranch Pipeline Jenkins project pointed at this repository:
   1. In Jenkins click on 'New Item'
   1. Enter 'jenkins-integration-sample' for the name and select 'Pipeline' as the project type
   1. Scroll down to the 'Pipeline' configuration and select 'Pipeline script from SCM'
   1. Select SCM as 'git'
   1. Give the following repository URL: https://github.com/GoogleCloudPlatform/jenkins-integration-samples.git
   1. Set the 'Script Path' to 'gke/Jenkinsfile'
   1. Save

Now you have a fully configured pipeline build!

