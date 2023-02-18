#!/bin/bash

ROOT_DIR="$(dirname $0)/../../../.."

source $ROOT_DIR/autogen.gh-secret.env

do_act() {
    local flow=$1
    local job=$2
    local cmd="act -v --directory $ROOT_DIR --container-architecture linux/amd64 -j $job"

    for secret in $(yq ".jobs.$job.env" $flow | sed -E 's/.+{{ secrets[.](.+) }}/\1/g'); do
        cmd="$cmd -s $secret=\$$secret"
    done

    bash -c "$cmd"
}

main() {
    for flow in $(ls $ROOT_DIR/.github/workflows/*.yaml); do
        for job in $(yq '.jobs | keys' $flow | sed 's/- //g'); do
            echo -n "Found job '$job' in '$(rev <<< $flow | cut -d '/' -f 1 | rev)'; Press [y] to continue: "
            read && [ $REPLY != 'y' ] && continue
            do_act $flow $job
        done
    done
}

main
