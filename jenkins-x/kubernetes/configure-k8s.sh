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
# for installing Jenkins X on a GKE cluster.
# It assumes the enviroment variables from the
# (../jenkins-x-env.sh) script have been configured and loaded.

# cleanup
export TMP_KEY_FILE="key.json"
function finish {
    rm $TMP_KEY_FILE
}
trap finish EXIT

# Retrieve the KubeConfig for the target GKE cluster
gcloud config set project $PROJECT_ID
gcloud container clusters get-credentials ${TF_VAR_cluster_name} \
       --zone $TF_VAR_cluster_zone

# Setup the required RBAC roles
kubectl get clusterrolebinding cluster-admin-binding &> /dev/null
if [ $? -eq 1 ]; then
   kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin \
           --user=$(gcloud config get-value account)
fi

kubectl get serviceaccount tiller --namespace kube-system &> /dev/null
if [ $? -eq 1 ]; then
    kubectl create serviceaccount tiller --namespace kube-system
fi

kubectl get clusterrolebinding tiller-admin-binding &> /dev/null
if [ $? -eq 1 ]; then
    kubectl create clusterrolebinding tiller-admin-binding --clusterrole=cluster-admin \
            --serviceaccount=kube-system:tiller
fi

# Execute the helm install/upgrade
helm init --service-account=tiller

# Configure Cloud DNS SA k8s secret
kubectl get secret external-dns-gcp-sa &> /dev/null
if [ $? -eq 1 ]; then
    gcloud iam service-accounts keys create $TMP_KEY_FILE \
           --iam-account ${TF_VAR_cloud_dns_sa_name}@$PROJECT_ID.iam.gserviceaccount.com
    kubectl create secret generic external-dns-gcp-sa \
            --from-file=$TMP_KEY_FILE
fi

