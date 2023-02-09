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
    -s AWS_ASG_USER_DATA=$AWS_ASG_USER_DATA \
    -s AWS_RDS_DBNAME=$AWS_RDS_DBNAME \
    -s AWS_RDS_PORT=$AWS_RDS_PORT \
    -s AWS_RDS_USERNAME=$AWS_RDS_USERNAME \
    -s AWS_RDS_PASSWORD=$AWS_RDS_PASSWORD \
    --container-architecture linux/amd64
