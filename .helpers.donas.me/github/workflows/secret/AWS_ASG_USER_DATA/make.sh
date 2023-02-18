#!/bin/bash

cat $(dirname $0)/userdata.sh \
    | sed "s/{{GH_ACCESS_TOKEN}}/$GH_ACCESS_TOKEN/g" \
    | sed "s/{{GH_OWNER}}/$GH_OWNER/g" \
    | sed "s/{{GH_REPO}}/$GH_REPO/g" \
    | sed "s/{{GH_BRANCH}}/$GH_BRANCH/g" \
    | sed "s/{{GH_PATH}}/$GH_PATH/g" \
    | base64
