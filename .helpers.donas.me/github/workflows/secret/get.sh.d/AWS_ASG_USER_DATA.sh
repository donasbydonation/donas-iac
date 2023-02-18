#!/bin/bash

set -e

# - Env
ROOT_DIR=${ROOT_DIR?"ERROR: Required environment variable not set"}
source $ROOT_DIR/.env.config
source $ROOT_DIR/.env.credentials

# - Config
TF_VAR_GET_PATH="$ROOT_DIR/.helpers.donas.me/terraform/var/get.sh.d"

# - Print
$TF_VAR_GET_PATH/AWS_ASG_USER_DATA.sh
