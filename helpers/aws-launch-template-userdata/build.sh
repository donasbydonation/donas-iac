#!/bin/bash

DIR=$(dirname $0)

source $DIR/gh_token.env

echo "Copying 'user_data' to clipboard..."
sed "s/{{GH_TOKEN}}/$GH_TOKEN/g" $DIR/userdata.sh | base64 | pbcopy
echo "Plz paste the copied 'user_data' to the repository secret"
