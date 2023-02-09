#!/bin/bash

ENV='../../cred.env'
if [ -f $ENV ]; then
    source $ENV
else
    echo "File 'cred.env' not exists in repository root" 1>&2; exit 1
fi

echo "Copying 'user_data' to clipboard..."
sed "s/{{GH_TOKEN}}/$GH_TOKEN/g" userdata.sh | base64 | pbcopy
echo "Plz paste the copied 'user_data' to the repository secret"
