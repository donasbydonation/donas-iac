#!/bin/bash

set -e

ROOT_DIR="$(dirname $0)/../../.."

source $ROOT_DIR/config.env
source $ROOT_DIR/config.cred.env

get-secret() {
    local name=$1

    if `ls $name/make.sh &> /dev/null`; then
        ./$name/make.sh
    elif `printenv $name &> /dev/null`; then
        printenv $name
    else
        echo "Value for the secret $name not exists" 1>&2; exit 1
    fi
}

set-secret() {
    local name=$1
    local value=$2

    gh secret -R $GH_OWNER/$GH_REPO set $name -b $value
}

main() {
    local REGEX='.+[$]{{ secrets[.](.+) }}$'
    local OUTPUT="$ROOT_DIR/autogen.gh-secret.env"

    echo "#!/bin/bash" > $OUTPUT
    for name in $(grep -E "$REGEX" $ROOT_DIR/.github/workflows/*.yaml | sed -E "s/$REGEX/\1/g" | sort -u); do
        local value=$(get-secret $name)
        echo "export $name='$value'" >> $OUTPUT
        set-secret $name $value
    done
}

main
