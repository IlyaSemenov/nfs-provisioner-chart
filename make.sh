#!/bin/bash -e

cd repo
helm package ../charts/nfs-provisioner
helm repo index .
chmod -x index.yaml
