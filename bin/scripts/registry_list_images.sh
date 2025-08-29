#!/usr/bin/env bash

set -e

fwd(){
    kubectl -n dev-tools port-forward svc/registry 5000:5000 &
    PID=$!
}

clean(){
    kill $PID
}
trap clean EXIT

# `cat` here helps with terminal rendering
list(){
    sleep 1
    echo -e "-------\n"
    curl -sk https://localhost:5000/v2/_catalog | jq -r '.repositories[]' | cat
}

main(){
    fwd
    list
}

main
