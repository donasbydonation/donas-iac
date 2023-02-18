#!/bin/bash

set -e

# - Env
ROOT_DIR=${ROOT_DIR?"ERROR: Required environment variable not set."}
CURR_DIR=$(cd $(dirname $0) && pwd)
source $ROOT_DIR/.env.config
source $ROOT_DIR/.env.credentials

# - Config
ENV_FILE_PATH="$ROOT_DIR/.env.autogen.docker-compose"
DC_YAML_FILE_PATH="$ROOT_DIR/docker/docker-compose.yaml"
YAML_OUT="$ROOT_DIR/docker-compose.autogen.yaml"

# - Dependency
$ROOT_DIR/.helpers.donas.me/docker/docker-compose/env/export.sh

# - Docker compose convert
cat << EOF > $YAML_OUT
# THIS FILE SHOULD NOT BE CHANGED MANUALLY AND SHOULD IGNORED BY '.gitignore'
# AUTOGEN INFO:
#   TIME: $(date)
#   SCRIPT: $CURR_DIR/$(basename $0)
EOF

docker compose \
    -f $DC_YAML_FILE_PATH \
    --env-file $ENV_FILE_PATH \
    convert \
    >> $YAML_OUT
