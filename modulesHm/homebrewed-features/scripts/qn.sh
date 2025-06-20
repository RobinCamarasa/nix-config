#!/usr/bin/env bash

# Initialization
SHARE_FOLDER="${HOME}/.local/share/qn"
mkdir -p "${SHARE_FOLDER}"

# Help
test "${1}" = "help" && ${EDITOR} -R $(realpath ${0}) && exit 0

# Get project
PROJECT="$(find "${SHARE_FOLDER}" -name '*.org' | xargs -I _ basename _ | sed -e 's/\.org$//' -e 's/^\s*//' | fzf --print-query | tail -n 1)"

# Edit
${EDITOR} ${SHARE_FOLDER}/${PROJECT}.org
