#!/usr/bin/env bash

split_path(){
	echo ${1} | tr ':' '\n' | while read -r path
	do 
		eval realpath "$path"
	done
}

if [[ $# -eq 1 ]]
then
    folder="${1}"
else
    folder=$(find $(split_path ${TSPATH}) -maxdepth 2 -name '.git' -type d | fzf | sed -e 's/\.git$//g')
fi

if [[ -z $folder ]]; then
    folder="/tmp"
fi

selected_name=$(basename "$folder" | tr . _)

if ! tmux has-session -t=$selected_name 2> /dev/null
then
    tmux -u new-session -ds $selected_name -c $folder

    if [[ -f "$folder/.tmux.sh" ]]; then
        tmux send-keys -t $selected_name "./.tmux.sh" C-m
    fi
fi

if [[ -z $TMUX ]]
then
    tmux -u attach -t $selected_name -c $folder
    exit 0
fi

tmux switch-client -t $selected_name

