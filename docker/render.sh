#!/bin/bash

cat << EOF 1>&2
[WARNING] render.sh does not check environment variables.
[WARNING] YOU MUST VERIFY THAT THE REQUIRED ENVS ARE AVAILABLE IN CURRENT SHELL SESSION.
EOF

DOCKER_COMPOSE_CONVERT="$(docker compose convert)" \
    gomplate -f setup-docker-compose.sh.tmpl
