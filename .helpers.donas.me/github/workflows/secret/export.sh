#!/bin/bash

set -e

# - Env
ROOT_DIR=${ROOT_DIR?"ERROR: Required environment variable not set."}
CURR_DIR=$(cd $(dirname $0) && pwd)
source $ROOT_DIR/.env.config
source $ROOT_DIR/.env.credentials

# - Configs
GH_SECRET_LIST_FILE_PATH="$ROOT_DIR/.github/workflows/*.yaml"
GH_SECRET_GET_DIR_PATH="$CURR_DIR/get.sh.d"
ENV_OUT="$ROOT_DIR/.env.autogen.gh-secrets"
GH_SECRET_OUT="$GH_OWNER/$GH_REPO"

# - Dependency
$ROOT_DIR/.helpers.donas.me/terraform/var/export.sh
source $ROOT_DIR/.env.autogen.docker-compose
source $ROOT_DIR/.env.autogen.tf-var

# - List
function list() {
    cat $GH_SECRET_LIST_FILE_PATH \
        | sed -E 's/([$]{{ secrets[.][A-Z_]+ }})/\1\n/g' \
        | grep -E '[$]{{ secrets[.][A-Z_]+ }}' \
        | sed -E 's/.*[$]{{ secrets[.]([A-Z_]+) }}.*/\1/g' \
        | sort -u
}

# - Get
function get() {
    local name=$1
    if [[ -f $GH_SECRET_GET_DIR_PATH/$name.sh ]]; then
        $GH_SECRET_GET_DIR_PATH/$name.sh
    else
        printenv $name \
            || (echo "ERROR: Required environment variable not set." 1>&2; exit 1)
    fi
}

# - Clear gh secrets
echo "INFO: Clearing gh secrets"
for name in $(gh secret -R $GH_SECRET_OUT list | awk '{print $1}'); do
    gh secret -R $GH_SECRET_OUT delete $name
done

# - Generate
cat << EOF > $ENV_OUT
#!/bin/bash

# THIS FILE SHOULD NOT BE CHANGED MANUALLY AND SHOULD IGNORED BY '.gitignore'
# AUTOGEN INFO:
#   TIME: $(date)
#   SCRIPT: $CURR_DIR/$(basename $0)
EOF

# - Set gh secrets
echo "INFO: Setting gh secrets"
for name in $(list); do
    value=$(get $name)
    echo "export $name='$value'" >> $ENV_OUT
    gh secret -R $GH_SECRET_OUT set $name -b $value
done
