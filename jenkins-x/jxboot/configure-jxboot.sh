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

# This file contains a script for executing the prerequisite steps
# for running jx boot.
# It assumes the enviroment variables from the
# (../jenkins-x-env.sh) script have been configured and loaded.

# fail on error
set -e

# cleanup
export TMP_PATCH_FILE=$(mktemp)
export TMP_YAML_FILE=$(mktemp)
function finish {
    rm $TMP_PATCH_FILE
    rm $TMP_YAML_FILE
}
trap finish EXIT

# Retrieve the IP address of the newly created address and store
# it in an environment variable.

export CLUSTER_IP=$(gcloud compute addresses describe --global $TF_VAR_cluster_address_name | grep "address:" | tr -s " " | cut -d " " -f2)

# Substitue environment variables within the [jx-requirements.patch.yaml](jx-requirements.patch.yaml) file.
envsubst < jx-requirements.patch.yaml > $TMP_PATCH_FILE

# Patch the [jx-requirements.yml](https://github.com/jenkins-x/jenkins-x-boot-config/blob/master/jx-requirements.yml)
# configuration file within the jenkins-x-boot-config project.
yaml-patch -o $TMP_PATCH_FILE < jenkins-x-boot-config/jx-requirements.yml > $TMP_YAML_FILE
cp $TMP_YAML_FILE jenkins-x-boot-config/jx-requirements.yml

