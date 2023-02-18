#!/bin/bash

set -e

export ROOT_DIR=$(pwd)
HOOK_NAME=$(basename $0)

# - Github
## - Secrets
echo "[$HOOK_NAME/github/sync-secrets] Sync GitHub action secrets..."
$ROOT_DIR/.helpers.donas.me/github/workflows/secret/export.sh

# - Sourcing generated env
source $ROOT_DIR/.env.config
source $ROOT_DIR/.env.credentials
source $ROOT_DIR/.env.autogen.docker-compose
source $ROOT_DIR/.env.autogen.tf-var
source $ROOT_DIR/.env.autogen.gh-secrets

# - Terraform
## - plan
echo "[$HOOK_NAME/terraform/plan] Planning TF codes..."
terraform -chdir=terraform plan

## - fmt
echo "[$HOOK_NAME/terraform/fmt] Formatting TF codes..."
for tf in $(terraform -chdir=terraform fmt); do
    if `git ls-files -m --exclude-standard | grep terraform/$tf &> /dev/null`; then
        git add terraform/$tf
        git commit -m "fmt: $tf"
    fi
done
