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

# Jenkins IaaS Bootstrapping with Terraform

This section outlines how to bootstrap the GCP IaaS resources
required for the the Jenkins X installation. This section makes use of the [Terraform](https://www.terraform.io/intro/index.html)
tool. Please ensure the Terraform CLI is installed prior to following these instructions.
It also assumes the environment variables outlined within the [../README.md](../README.md)
document have been configured and loaded.

## Steps

1. Export the GCP SA key you'll be using for Terraform:
```bash
gcloud iam service-accounts keys create ${GOOGLE_CLOUD_KEYFILE_JSON} \
    --iam-account ${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
```

2. Initialize the Terraform GCP provider:
```bash
cd jenkins-x/terraform/
terraform init
```

3. Generate the Terraform plan writing out the results to a file. Examine the contents of
    the $TF_PLAN_FILE to verify correctness:
```bash
terraform plan -out ${TF_PLAN_FILE}
```

4. Apply the Terraform plan:
```bash
terraform apply ${TF_PLAN_FILE}
```

5. Retrieve the name servers from the newly created Cloud DNS managed zone, and
configure your domain to use them via your domain registrar's web interface:
```bash
gcloud dns record-sets list --zone=${TF_VAR_cloud_dns_managed_zone_name} \
    | grep "NS" | tr -s ' ' | cut -d' ' -f4
```
