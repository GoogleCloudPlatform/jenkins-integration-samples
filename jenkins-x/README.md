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

# Jenkins X GCP Playbook

This guide provides a "playbook" as defined within the [Google SRE Book](https://landing.google.com/sre/sre-book/chapters/introduction/)
for installing [Jenkins X](https://jenkins-x.io/), (aka **jx**), on [GCP](https://cloud.google.com/)
using recommended best practices. It adopts the [GitOps](https://www.cloudbees.com/gitops/what-is-gitops)
approach, defining the underlying GCP [IaaS](https://en.wikipedia.org/wiki/Infrastructure_as_a_service) infrastructure
with configuration as code using [Terraform](https://www.terraform.io/),
a tool which has become an industry standard for defining and
deploying IaaS instracture. Many projects and businesses have existing Terraform based IaaS provisioning
workflows, the idea within this guide is to provide a resources which an be incorporated into these
existing workflows. Finally, this guide leverages [jx boot](https://jenkins-x.io/docs/getting-started/setup/boot/)
on [GCP](https://cloud.google.com/) to drive the jx installation process.

## Catostrophic Recovery

While jx boot does a good job of creating a GitOps environment post installation,
it still relies on a manual "wizard-like" workflow for the initial boostrapping.
As manual workflows can be error prone, (especially during times of stress like outages),
this playbook defines reproducable steps for bootstrapping in the case of
catostrophic recovery. It utilizes automation where possible with Terraform as well
as scripts which glue settings between Terraform and jx boot. Any remaining manual processes
are enumerated with well-defined copy/paste steps. This document also attempts to assuage current
pain points encountered during the jx installation process, and thus serves as a living
friction log for the project. The ultimate goal is to have these pain points addressed
within jx, thus reducing the size of this playbook considerably.

## Questions

Developers and users of jx are available to answer questions on the **#jenkins-x-user** Slack
channel on: [http://kubernetes.slack.com/](http://kubernetes.slack.com/)

Additionally, GCP engineers and users are available on the **#gcp-jenkins** Slack channel on: [http://bit.ly/gcp-slack](http://bit.ly/gcp-slack)

## Steps

This guide provides defined steps for reproducibly installing jx onto a [GKE](https://cloud.google.com/kubernetes-engine/)
cluster. It makes use of the following CLI tools assuming each is installed
and accessible on the $PATH:

* [gcloud](https://cloud.google.com/sdk/)
* [terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
* [jx](https://jenkins-x.io/docs/getting-started/setup/install/)
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [envsubst](https://linux.die.net/man/1/envsubst)
* [yaml-patch](https://github.com/krishicks/yaml-patch#installing)
* [helm](https://helm.sh/docs/intro/install/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

If you don't already have one, [sign up for a Google account](https://accounts.google.com/SignUp).

### Clone This Repository

The Terraform resources and setup scripts provided by this guide can be utilized best
by cloning this repository locally. Additionally, post-installation, it can serve as the basis
for your project's GitOps repository for bootstrapping your jx installation.
**Always take care not to publish keys or other sensitive information to public repositories**.
```bash
git clone https://github.com/GoogleCloudPlatform/jenkins-integration-samples.git
cd jenkins-integration-samples/jenkins-x
```

#### Installation Environment Variables

This section outlines the steps for setting up the required
installation environment variables utilized throughout this process.

1. Setup the required installation environment variables within
the [jenkins-x-env.sh][jenkins-x-env.sh] file by replacing each value
labeled: "[FILL_ME_IN]" with an appropriate configuration value.

2. Load the environment variables into the current session:
```bash
    source jenkins-x-env.sh
```

### Enable Required Services

Enable the services required to install Jenkins X on GKE:
```bash
gcloud services enable storage-api.googleapis.com container.googleapis.com containerregistry.googleapis.com dns.googleapis.com cloudresourcemanager.googleapis.com
```

### Bootstrap GCP Service Account

A boostrap GCP service account (SA) is utilized throughout the rest of the
installation process. This section ensures your GCP SA is provisioned
with the necessary permissions. **Note**: this service account should only
be used for IaaS resource provisioning and not for integration tests. Ideally
this server account should be removed after installation. If you don't have an
existing have GCP SA (service account) you want to use, provision a new one:
``` bash
gcloud beta iam service-accounts create ${SA_NAME} \
    --display-name "${SA_NAME}"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com \
    --role roles/owner
```

### Bootstrap GCP IaaS resources

Follow the instructions outlined within the [terraform/README.md](terraform/README.md)
document for bootstrapping the required GCP IaaS resources.

### Kubernetes Setup

Follow the instructions outlined within the [kubernetes/README.md](kubernetes/README.md)
document for configuring the pre-requisites for running jx boot on your GKE cluster.

### jx boot

Follow the instructions outlined within the [jxboot/README.md](jxboot/README.md)
document for configuring and running jx boot to install jx.

### Cleanup

Finally, for best security practices you'll want to destroy the service account used
during this bootstrapping process, as it's no longer needed:
```bash
gcloud beta iam service-accounts delete ${SA_NAME}
```

### jx boot Tips & Tricks

This section contains tips and tricks for navigating the jx installation process.

#### If at first you don’t succeed, try again.

* A common type of error encountered during the jx boot process:
```bash
error: waiting for vault service: service jx-vault-devops-eu-201 never became ready
error: failed to interpret pipeline file jenkins-x.yml: failed to run '/bin/sh -c jx step boot vault --provider-values-dir ../../kubeProviders' command in directory 'systems/vault', output: ''
```

* Solution: Run the command again, often times errors like these are the result
of provisioning timeouts not be properly calibrated.

