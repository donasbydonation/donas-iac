#!/bin/bash

set -e

ROOT_DIR=${ROOT_DIR?"ERROR: Required environment variable not set"}
TF_DIR="$ROOT_DIR/terraform"

terraform -chdir=$TF_DIR state show $(terraform -chdir=$TF_DIR state list | grep aws_db_instance) \
    | grep address \
    | sed -E 's/.+"(.+)"/\1/g'
