#!/bin/bash

ROOT='../../..'
ENV=$ROOT/cred.env
if [ -f $ENV ]; then
    source $ENV
else
    echo "File 'cred.env' not exists in repository root" 1>&2; exit 1
fi

act -v \
    --directory $ROOT \
    -j terraform-apply \
    -s AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -s AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -s TF_VAR_AWS_ASG_USER_DATA=$TF_VAR_AWS_ASG_USER_DATA \
    --container-architecture linux/amd64
