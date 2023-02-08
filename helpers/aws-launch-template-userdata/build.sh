#!/bin/bash

DIR=$(dirname $0)

source $DIR/gh_token.env

sed "s/{{GH_TOKEN}}/$GH_TOKEN/g" $DIR/userdata.sh \
    | base64 \
    > $DIR/../../aws/data/ec2-userdata.b64
