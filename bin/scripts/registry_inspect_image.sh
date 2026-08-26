#!/usr/bin/env bash

IMAGE=$1
if [[ -z "$IMAGE" ]]; then
  echo "Please provide an image"
  exit
fi

fwd(){
    kubectl -n dev-tools port-forward svc/registry 5000:5000 &
    PID=$!
}

clean(){
    kill $PID
}

trap clean EXIT

inspect(){
    sleep 1
    echo -e "-------\n"
    curl -k \
      https://localhost:5000/v2/"$IMAGE"/tags/list  2> /dev/null || \
      { printf "[ERROR] $IMAGE not found. Please check spelling and current images"; exit 1; }
}

main(){
	fwd
	inspect

}

main
