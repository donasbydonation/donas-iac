#!/bin/bash

for hook in $(ls *.sh); do
    chmod +x $hook
    if [[ $hook == $(basename $0) ]]; then continue; fi
    cp $hook ../.git/hooks/$(sed -E 's|(.+)[.]sh|\1|g' <<< "$hook")
done
