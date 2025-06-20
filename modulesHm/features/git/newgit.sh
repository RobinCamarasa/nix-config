#!/usr/bin/env bash

# Initialization
SHARE_FOLDER="${HOME}/.local/share/newgit"
SHARE_PRJ_FILE="${SHARE_FOLDER}/projects"

mkdir -p "${SHARE_FOLDER}"
touch "${SHARE_PRJ_FILE}"

test "${1}" == "edit" && ${EDITOR} ${SHARE_PRJ_FILE} && exit 0
test "${1}" == "help" && ${EDITOR} -R $(realpath ${0}) && exit 0

# Get project
PROJECT="$(cat ${SHARE_PRJ_FILE} | fzf --print-query | tail -n 1)"

# Update the project list
echo ${PROJECT} >> ${SHARE_PRJ_FILE}
sort -uo ${SHARE_PRJ_FILE} ${SHARE_PRJ_FILE}

# Clone
GIT_RMT="$(wl-paste)"
SUFFIXPATH="$(echo ${GIT_RMT} | sed -e 's/\.git$//g' | tr '/' '\n' | tail -n 1 | tr ' ' '_' | tr '[:upper:]' '[:lower:]')"

git clone "${GIT_RMT}" "$(realpath ${NGPATH})/${PROJECT}-${SUFFIXPATH}"
