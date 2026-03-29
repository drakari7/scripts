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

mlog(){
    ssh -t "${1}" 'cd /home/melzi-prod/melzi/crypto_prod/main/log; bash -l'
}

blog(){
    ssh -t "${1}" 'cd /home/melzi-prod/melzi/crypto/beta/log; bash -l'
}

prodssh() {
    # box=$(grep -A1 "${1}$" ~/.ssh/config | grep "Hostname" | awk '{print $NF}')
    # ssh -t melzi-prod@mlz5 "ssh ${box}"
    ssh "melzi-prod@${1}"
}

gcp() {
    git commit -m "${1} #auto_promote"
}

ts() {
    date -d @${1:0:10}
}

scplog() {
    cd ~/random
    scp -l 500000 ${1}:~/log log
    cp log log.bak
    nvim log
}

prodscplog() {
    cd ~/random
    scp -l 500000 melzi-prod@${1}:~/log log
    cp log log.bak
    nvim log
}
