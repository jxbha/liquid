#!/bin/sh
#common.sh

set -e

build_image(){
    local image=$1
    local base_image=$2
    local packages=$3
    local extra_run=${4:-}

    local run_command="apk add --no-cache $packages && update-ca-certificates"
    if [ -n "$extra_run" ]; then
        run_command="$run_command && $extra_run"
    fi
    run_command="$run_command && rm -rf /var/cache/apk/*"


    if [ ! -f /cert/ca.crt ]; then
      printf "[ERROR] cert missing from /cert/ca.crt ; check secrets"
      exit 1
    fi
    mkdir -p /tmp/build-context
    cp /cert/ca.crt /tmp/build-context/ca.crt


    full_image="$REGISTRY/$image"

    cat > /tmp/build-context/Dockerfile <<DOCKERFILE
FROM $REGISTRY/$base_image
COPY ca.crt /usr/local/share/ca-certificates/ca.crt
RUN $run_command
DOCKERFILE

    buildctl-daemonless.sh build \
    --frontend=dockerfile.v0 \
    --local context=/tmp/build-context \
    --local dockerfile=/tmp/build-context \
    --output type=image,name=$full_image,push=true

}
