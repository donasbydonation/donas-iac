#!/bin/bash

set -e

source ./config.env
source ./config.cred.env

# -------------------------
# GitHub settings
# -------------------------
echo "[github/repository-secrets] Sync github repository secrets..."
./helpers/github/secret/gsync.sh
source ./autogen.gh-secret.env
echo

echo "[github/repository-secrets] Used AWS ASG user_data is:"
base64 -d <<< "$AWS_ASG_USER_DATA"
echo

# -------------------------
# Docker settings
# -------------------------
echo "[docker/docker-compose] Generating 'docker-compose.b64' file..."
./helpers/docker/make-b64.sh
echo

echo "[docker/docker-compose] Committing changes if exists..."
if `git ls-files -m --exclude-standard | grep docker/docker-compose.b64 &> /dev/null`; then
    git add docker/docker-compose.b64
    git commit -m "fix: docker-compose.b64 (autocommit; reason unknown)"
fi
echo

echo "[docker/docker-compose] Used docker-compose.yaml is:"
base64 -d docker/docker-compose.b64
echo

# -------------------------
# Terraform settings
# -------------------------
cd aws
echo "[terraform/plan] Planning terraform infrastructure..."
source ./shim.env
terraform plan
echo

echo "[terraform/fmt] Formatting terraform codes..."
terraform fmt -diff
cd ..
if `git ls-files -m --exclude-standard | grep aws/ &> /dev/null`; then
    git add aws/
    git commit -m "chore: fmt"
fi
echo
