#!/bin/bash

source "$(pwd)/donas.me"
GH_REMOTE="$GH_OWNER/$GH_REPO"

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
