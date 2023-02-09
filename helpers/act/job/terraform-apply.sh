#!/bin/bash

source terraform-apply.env

echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
echo "TF_VAR_AWS_ASG_USER_DATA=$TF_VAR_AWS_ASG_USER_DATA"

act -v \
    --directory ../../../ \
    -j terraform-apply \
    -s AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -s AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -s TF_VAR_AWS_ASG_USER_DATA=$TF_VAR_AWS_ASG_USER_DATA \
    --container-architecture linux/amd64
