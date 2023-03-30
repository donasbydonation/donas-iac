#!/bin/bash

source "$(pwd)/donas.env"
GH_REMOTE="$GH_OWNER/$GH_REPO"


#
# TF_VAR_ synchronization
#
function list-tf-vars() {
    local REGEX='^variable "([A-Z_]+)" {$'
    cat terraform/variables.tf \
        | grep -E "$REGEX" \
        | sed -E "s/$REGEX/\1/g"
}

for name in $(list-tf-vars); do
    if `grep TF_VAR_$name .github/workflows/*.yaml &> /dev/null`; then
        echo "[INFO] Env 'TF_VAR_$name' is defined in worklows."
        sleep 0.2
    else
        echo "[ERROR] Env 'TF_VAR_$name' not defined in workflows." 1>&2
        exit 1
    fi
done

#
# GitHub secret synchronization
#
function list-gh-secrets() {
    cat .github/workflows/*.yaml \
        | sed -E 's/([$]{{ secrets[.][A-Z_]+ }})/\1\n/g' \
        | grep -E '[$]{{ secrets[.][A-Z_]+ }}' \
        | sed -E 's/.*[$]{{ secrets[.]([A-Z_]+) }}.*/\1/g' \
        | sort -u
}

for name in $(gh secret -R $GH_REMOTE list | awk '{print $1}'); do
    gh secret -R $GH_REMOTE delete $name
done

for name in $(list-gh-secrets); do
    gh secret -R $GH_REMOTE set $name -b "$(printenv $name)"
done
