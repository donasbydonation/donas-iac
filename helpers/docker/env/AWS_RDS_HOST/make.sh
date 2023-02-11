#!/bin/bash

set -e

ROOT_DIR="$(dirname $0)/../../../.."
echo $ROOT_DIR

source $ROOT_DIR/config.env
source $ROOT_DIR/config.cred.env

main() {
    cd $ROOT_DIR/aws
    terraform state show $(terraform state list | grep aws_db_instance) \
        | grep address \
        | sed -E 's/.+"(.+)"/\1/g'
}

main
