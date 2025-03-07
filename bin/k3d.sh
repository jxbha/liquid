#!/bin/bash

set -e
NOW=`date +'%Y-%m-%d'`
TEMPFILE=$NOW.tmp
HOST_INTERFACE=$(ip addr show | awk '/inet.*brd/{print $NF; exit}')
ADDRESS=$(ip -o -4 addr show $HOST_INTERFACE | awk -F '[/ ]' '{ print $7 }')

display_help(){
    #echo -e "Options:\n\tinit\n\tinstall\n\tupgrade\n\tget\n\tclean"
    echo "Usage: $0 <command> [options]"
    echo "Available options:"
    echo "  init      Run full bootstrap"
}

init() {
    PORT=$(docker ps -f name=jx-registry --format '{{.Ports}}' | head -c 13 | tail -c 5) #this isn't necessary at the moment because we're hardcoding the nodeport for simplicity.
    REGISTRY="k3d-jx-registry:$PORT"
    REGISTRY_IP=$(docker inspect k3d-jx-registry | jq -r '.[].NetworkSettings.Networks."jx-env".IPAddress')

    create_registry
    prepare_registry
    create_cluster($ADDRESS)
    k3d kubeconfig get jx > $TEMPFILE
    # TODO: replace values in-place in ~/.kube/
    sed -i s/'0.0.0.0'/$HOST_IP/ $TEMPFILE
    kubectl config set-context $TEMPFILE
    deploy


    #rm $TEMPFILE
}

create_registry(){
    # make idempotent
    echo "Creating registry..."
    k3d registry create jx-registry --default-network jx-env --proxy-password admin --proxy-username admin --port 33335
}

create_cluster($ADDRESS){
    # make idempotent
    echo "Creating cluster..."
    k3d cluster create -v /opt/k8s/vol/2:/opt/k8s/vol/2 -v /opt/k8s/vol/3:/opt/k8s/vol/3 -p 30000-30100:30000-30100@server:0 --api-port 8888 --registry-use jx-registry --network jx-env --k3s-arg '--tls-san=$(ADDRESS)@server:0' --k3s-arg '--kubelet-arg=feature-gates=KubeletInUserNamespace=true@server:0' jx
}

prepare_registry(){
    echo "Bootstrapping registry..."
    registry_helper
    registry_jxwb
    registry_kubectl
    registry_golang
    registry_mongo
    update_registry_source
}

registry_helper(){
    docker tag helper:latest k3d-jx-registry.localhost:$PORT/helper:latest
    docker push k3d-jx-registry.localhost:$PORT/helper:latest

}
registry_jxwb(){
    docker tag localhost/jxwb:latest k3d-jx-registry.localhost:$PORT/jxwb:latest
    docker push k3d-jx-registry.localhost:$PORT/jxwb:latest

}
registry_kubectl(){
    docker tag bitnami/kubectl:latest k3d-jx-registry.localhost:$PORT/kubectl:latest
    docker push k3d-jx-registry.localhost:$PORT/kubectl:latest

}
registry_golang(){
    docker tag golang:1.20 k3d-jx-registry.localhost:$PORT/golang:1.20
    docker push k3d-jx-registry.localhost:$PORT/golang:1.20

}
registry_mongo(){
    docker tag mongo k3d-jx-registry.localhost:$PORT/mongo
    docker push k3d-jx-registry.localhost:$PORT/mongo
}

update_registry_source(){
# TODO: This should not be `latest`
    echo "Updating values..."
    if [ $(uname) == "Linux" ]; then
        sed -i "15 s/.*/        - image: $REGISTRY\/jxwb:latest/" ./app/deployment.yaml
    elif [ $(uname) == "Darwin" ]; then
        # mac
        gsed -i "15 s/.*/         -image: $REGISTRY\/jxwb:latest/" ./app/deployment.yaml
    fi
}

deploy() {
    :
}

test() {
    echo "Testing deployment endpoint:"
    curl localhost:30050/livez
}

main() {
    case "$1" in
        "help")
            display_help
            ;;
        "init")
            init
            ;;
        "create_registry")
            create_registry
            ;;
        "create_cluster")
            create_cluster($ADDRESS)
            ;;
        "deploy")
            deploy
            ;;
        "prepare_registry")
            prepare_registry
            ;;
        "test")
            test
            ;;
        "clean")
            clean
            ;;
        *)
            run
            ;;
    esac

    log "Completed."
}

main "$1"
