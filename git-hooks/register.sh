#!/bin/bash

for hook in $(ls *.sh); do
    chmod +x $hook

    if [[ $hook == $(basename $0) ]]; then
        continue
    fi

    no_sh=$(sed -E 's|(.+)[.]sh|\1|g' <<< "$hook")
    if [[ -f ../.git/hooks/$no_sh.sample ]]; then
        cp $hook ../.git/hooks/$no_sh
    fi
done
