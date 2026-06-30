#!/bin/zsh

gd() {
    if [[ $1 =~ ^[0-9]+$ ]]; then
        local num=$1; shift
        git diff "HEAD~${num}" HEAD "$@"
    else
        git diff "$@"
    fi
}

ts() {
    date -d "@${1:0:10}"
}

# rgp <search-regex> <path-regex> [extra rg flags...]
# Search for <search-regex> inside files whose PATH matches <path-regex> (both regex).
#   rgp "some string" 'clusters.*evrec'
#   rgp "some string" evrec -i        # path containing 'evrec', case-insensitive
rgp() {
    [[ $# -ge 2 ]] || { echo "usage: rgp <search-regex> <path-regex> [rg flags]" >&2; return 1; }
    local pat=$1 pathre=$2; shift 2
    fd -tf -p -0 "$pathre" | xargs -0 -r rg "$@" -e "$pat"
}

# last <files/dirs>: open the most-recently-modified match in less.
last() {
    local f
    f=$(ls -t -- "$@" 2>/dev/null | head -1)
    [[ -n $f ]] && less -- "$f"
}

# ---------------------- Blocktech -------------------------------

# bump <glob> <version>: update the "version:" line in clusters/<glob> files.
# Run from a config root dir (the one containing clusters/).
bump() {
    if [[ $# -ne 2 ]]; then
        echo "usage: bump <glob> <version>" >&2
        return 1
    fi
    local glob=$1 version=$2
    # ${~glob} forces globbing of the variable's contents; (N) = nullglob (empty if no match).
    local files=(clusters/${~glob}(N))
    if (( ${#files} == 0 )); then
        echo "no files match: clusters/$glob" >&2
        return 1
    fi
    local f
    for f in $files; do
        sed -i "s|^version:.*|version: $version|" "$f"
        echo "updated: $f"
    done
}

# ---------------------- Blocktech -------------------------------
