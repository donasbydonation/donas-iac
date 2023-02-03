#!/bin/bash

source terraform-apply.env

act -v \
    --directory ../../../ \
    -j terraform-apply \
    -s AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -s AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    --container-architecture linux/amd64
