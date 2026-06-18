#!/bin/bash

gd (){
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]] ; then
        git diff $@
    else
        num="${1}"
        shift
        git diff HEAD~${num} HEAD $@
    fi
}

ts() {
    date -d @${1:0:10}
}

# rgp <rg-pattern> <path-pattern>: ripgrep within files whose path matches the pattern.
rgp() {
    fd -tf -p ${2} | xargs rg ${1}
}

# last <glob/files>: open the last (alphabetically) matching file in less.
last() {
    less "$(ls "$@" | tail -1)"
}

# ---------------------- Blocktech -------------------------------

# bump <glob> <version>: update the "version:" line in clusters/<glob> files.
# Run from a config root dir (the one containing clusters/).
bump() {
    (
        set -euo pipefail
        if [[ $# -ne 2 ]]; then
            echo "usage: bump <glob> <version>" >&2
            exit 1
        fi
        local glob="$1" version="$2"
        shopt -s nullglob
        local files=(clusters/$glob)
        if [[ ${#files[@]} -eq 0 ]]; then
            echo "no files match: clusters/$glob" >&2
            exit 1
        fi
        local f
        for f in "${files[@]}"; do
            sed -i "s|^version:.*|version: $version|" "$f"
            echo "updated: $f"
        done
    )
}

# ---------------------- Blocktech -------------------------------
