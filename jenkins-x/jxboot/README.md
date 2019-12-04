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

# jx boot Setup

This section outlines how to configure and run [jx boot](https://jenkins-x.io/docs/getting-started/setup/boot/)
to install Jenkins X into your GKE cluster. This section assumes all
required IaaS resources have been provisioned using the process outlined within the
[terraform/README.md](../terraform/README.md) document. This section also
assumes that the steps defined within the [helm/README.md](../helm/README.md) document
have been followed. This section makes use of the
following tools assuming each is installed and accessible on the $PATH:

* [jx](https://jenkins-x.io/docs/getting-started/setup/install/)
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [envsubst](https://linux.die.net/man/1/envsubst)
* [yaml-patch](https://github.com/krishicks/yaml-patch#installing)

It also assumes the environment variables outlined within the
[../README.md](../README.md) document have been configured and loaded.

Further reference information on jx boot and the Jenkins X install
process can be found here: https://jenkins-x.io/docs/getting-started/setup/boot/

## Steps

1. Clone the [jenkins-x-boot-config](https://github.com/jenkins-x/jenkins-x-boot-config)
```bash
cd jenkins-x/jxboot
git clone https://github.com/jenkins-x/jenkins-x-boot-config.git
```

2. Execute the [configure-jxboot.sh](configure-jxboot.sh) script:
```bash
./configure-jxboot.sh
```

5. Run jx boot
```bash
cd jenkins-x-boot-config
jx boot
```
