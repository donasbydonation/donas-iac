#!/bin/bash

set -e

ROOT_DIR=${ROOT_DIR?"ERROR: Required environment variable not set"}
TF_DIR="$ROOT_DIR/terraform"

terraform -chdir=$TF_DIR output AWS_RDS_HOST \
    | sed -E 's/"(.+)"/\1/g'
