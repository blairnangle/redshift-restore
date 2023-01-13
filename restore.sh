#!/bin/bash

set -e -o pipefail

# create a manual snapshot of production and assign identifier to a variable
echo "creating a manual snapshot of production cluster…"
SNAPSHOT_IDENTIFIER="$(./snapshot.py)"
echo "snapshot to be restored: $SNAPSHOT_IDENTIFIER"

# restore the snapshot to staging cluster by re-applying Terraform plan (this will force a cluster replacement if one already exists)
echo "provisioning staging cluster from production snapshot using Terraform…"
cd staging || exit
export AWS_PROFILE=staging
terraform init
terraform apply -var "snapshot_identifier=${SNAPSHOT_IDENTIFIER}"
