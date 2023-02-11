#!/bin/bash

set -e

ROOT_DIR="$(dirname $0)/../.."

source $ROOT_DIR/config.env
source $ROOT_DIR/config.cred.env

validate() {
    local dir=$1

    if ! `docker compose -f $dir/docker-compose.yaml convert -q &> /dev/null`; then
        docker compose -f $dir/docker-compose.yaml convert -q 1>&2; exit 1
    fi
}

get-list() {
    local dir=$1

    cat $dir/docker-compose.yaml \
        | sed -E 's/([$]{[A-Z_]+})/\1\n/g' \
        | grep -E '[$]{[A-Z_]+}' \
        | sed -E 's/.*[$]{([A-Z_]+)}.*/\1/g' \
        | sort -u
}

get-env() {
    local name=$1

    if `ls ./env/$name/make.sh &> /dev/null`; then
        ./env/$name/make.sh
    elif `printenv $name &> /dev/null`; then
        printenv $name
    else
        echo "Required environment variable '$name' not exists" 1>&2; exit 1
    fi
}

main() {
    for filepath in $(find $ROOT_DIR -name 'docker-compose.yaml'); do
        local dir=$(dirname $filepath)

        validate $dir

        echo "#!/bin/bash" > $dir/docker-compose.env
        for name in $(get-list $dir); do
            echo "export $name=$(get-env $name)" >> $dir/docker-compose.env
        done

        docker compose \
            -f $dir/docker-compose.yaml \
            --env-file $dir/docker-compose.env \
            convert \
            | base64 \
            > $dir/docker-compose.b64

        rm $dir/docker-compose.env
    done
}

main