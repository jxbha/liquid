#!/usr/bin/env bash

DIR="$(dirname "$0")"
CACRT="$ROOT/config/ssl/ca.crt"
CONFIG="$ROOT/config/ssl/ca.cnf"

keycheck(){
    # checks for the CA private key. 
    # if the env var doesn't exist, there's a workspace problem: run envsetup again.
    # if the file doesn't exist, create it!
   
    if [[ -z "$CA_KEY_FILE" ]]; then
        # Under DEVSPACE conditions from envsetup, this should be set.
        echo "Private key file path not loaded. Double-check workspace and env file."
        exit 1
    fi

    if [[ -f "$CA_KEY_FILE" ]]; then
        return
    fi

    openssl genrsa -out "$CA_KEY_FILE" 4096
    chmod 600 "$CA_KEY_FILE"
}

root(){
    if [[ ! -f "$CACRT" ]]; then
        openssl req -x509 -new -noenc -batch \
            -config "$CONFIG" \
            -sha256 -days 3650 \
            -out "$CACRT"
    fi
    
    kubectl create secret generic tls-ca \
    --from-file=ca.crt="$CACRT" \
    --namespace dev-tools \
    --dry-run=client \
    --output yaml > tls-ca-secret.yaml
    
    kubectl apply -f tls-ca-secret.yaml
} 

server(){
    # Generate key
    openssl genrsa -out server.key 4096

    # Generate CSR
    openssl req -new \
        -subj "/C=US/ST=TX/L=Austin/O=Cathedral/CN=*.jbernh.xyz" \
        -config "$CONFIG" -reqexts external_cert \
        -key server.key \
        -out server.csr

    # Sign CSR
    openssl x509 -req -in server.csr \
        -CA "$CACRT" -CAkey "$CA_KEY_FILE" \
        -copy_extensions copy -days 365 \
        -out server.crt

    # Verify cert
    openssl verify -CAfile "$CACRT" server.crt

    # Create secret
    kubectl create secret tls tls-server \
        --cert=server.crt --key=server.key \
        --namespace dev-tools \

    kubectl create secret tls tls-server \
        --cert=server.crt --key=server.key \
        --namespace app \

    # Clean up
    rm server.csr server.crt server.key
}

internal(){
    # Generate key
    openssl genrsa -out internal.key 4096

    # Generate CSR
    openssl req -new \
        -subj "/C=US/ST=TX/L=Austin/O=Cathedral/CN=*.dev-tools.svc.cluster.local" \
        -config "$CONFIG" -reqexts internal_cert \
        -key internal.key \
        -out internal.csr

    # Sign CSR
    openssl x509 -req -in internal.csr \
        -CA "$CACRT" -CAkey "$CA_KEY_FILE" \
        -copy_extensions copy -days 365 \
        -out internal.crt

    # Verify cert
    openssl verify -CAfile "$CACRT" internal.crt

    # Create secret
    kubectl create secret tls tls-internal \
        --cert=internal.crt --key=internal.key \
        --namespace dev-tools \

    kubectl create secret tls tls-internal \
        --cert=internal.crt --key=internal.key \
        --namespace app \

    # Clean up
    rm internal.csr internal.crt internal.key
}

main() {
    local command="$1"

    keycheck

    case "$command" in
        root)
            root
            ;;
        server)
            server
            ;;
        internal)
            internal
            ;;
        *)
            server
            internal
            ;;
    esac
}

main "$@"
