#!/bin/bash

set -e

# - Env
ROOT_DIR=${ROOT_DIR?"ERROR: Required environment variable not set"}
source $ROOT_DIR/.env.config
source $ROOT_DIR/.env.credentials

# - Config
DOCKER_ENV_GET_PATH="$ROOT_DIR/.helpers.donas.me/docker/env/get.sh.d"
ENV_OUT="$ROOT_DIR/.env.autogen.docker-compose"

# - Autogen
function get_env_list() {
    cat $ROOT_DIR/docker/docker-compose.yaml \
        | sed -E 's/([$]{[A-Z_]+})/\1\n/g' \
        | grep -E '[$]{[A-Z_]+}' \
        | sed -E 's/.*[$]{([A-Z_]+)}.*/\1/g' \
        | sort -u
}

cat << EOF > $ENV_OUT
#!/bin/bash

# THIS .env FILE IS AUTOGENERATED AT TIME: $(date)
# THIS FILE SHOULD NOT BE CHANGED MANUALLY AND
# SHOULD IGNORED BY '.gitignore'

EOF

for env_name in $(get_env_list); do
    if [[ -f $DOCKER_ENV_GET_PATH/$env_name.sh ]]; then
        echo "export $env_name='$($DOCKER_ENV_GET_PATH/$env_name.sh)'"  >> $ENV_OUT
    elif `printenv $env_name &> /dev/null`; then
        echo "export $env_name='$(printenv $env_name)'"  >> $ENV_OUT
    else
        echo "ERROR: Required environment variable $env_name not set" 1>&2; exit 1
    fi
done

# - Docker compose convert
docker compose \
    -f $ROOT_DIR/docker/docker-compose.yaml \
    --env-file $ENV_OUT \
    convert \
    | base64
