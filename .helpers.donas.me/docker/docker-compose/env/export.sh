#!/bin/bash

set -e

# - Env
ROOT_DIR=${ROOT_DIR?"ERROR: Required environment variable not set."}
CURR_DIR=$(cd $(dirname $0) && pwd)
source $ROOT_DIR/.env.config
source $ROOT_DIR/.env.credentials

# - Config
DC_ENV_LIST_FILE_PATH="$ROOT_DIR/docker/docker-compose.yaml"
DC_ENV_GET_DIR_PATH="$CURR_DIR/get.sh.d"
ENV_OUT="$ROOT_DIR/.env.autogen.docker-compose"

# - Autogen
function list() {
    cat $DC_ENV_LIST_FILE_PATH \
        | sed -E 's/([$]{[A-Z_]+})/\1\n/g' \
        | grep -E '[$]{[A-Z_]+}' \
        | sed -E 's/.*[$]{([A-Z_]+)}.*/\1/g' \
        | sort -u
}

# - Get
function get() {
    local name=$1
    if [[ -f $DC_ENV_GET_DIR_PATH/$name.sh ]]; then
        $DC_ENV_GET_DIR_PATH/$name.sh
    else
        printenv $name \
            || (echo "ERROR: Required environment variable not set." 1>&2; exit 1)
    fi
}

# - Generate
cat << EOF > $ENV_OUT
#!/bin/bash

# THIS FILE SHOULD NOT BE CHANGED MANUALLY AND SHOULD IGNORED BY '.gitignore'
# AUTOGEN INFO:
#   TIME: $(date)
#   SCRIPT: $CURR_DIR/$(basename $0)

EOF

for name in $(list); do
    value=$(get $name)
    echo "export $name='$value'" >> $ENV_OUT
done
