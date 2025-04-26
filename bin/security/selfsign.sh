server(){
    # openssl genrsa -out root.key 2048
    openssl req -x509 -new -nodes -subj "/C=US/ST=Texas/L=Austin/CN=*.dev-tools.svc.cluster.local" -addext "subjectAltName = DNS:*.dev-tools.svc.cluster.local" -key $ROOTKEY -sha256 -days 3650 -out root.crt
    openssl genrsa -out server.key 2048
    openssl req -new -subj "/C=US/ST=Texas/L=Austin/CN=jbernh.xyz" -addext "subjectAltName = DNS:*.jbernh.xyz, DNS:jbernh.xyz" -key server.key -out server.csr
    openssl x509 -req -in server.csr -CA root.crt -CAkey $ROOTKEY -CAcreateserial -copy_extensions=copy -days 3650 -out server.crt
    openssl verify -CAfile root.crt server.crt
    kubectl create secret tls secret-server --cert=server.crt --key=server.key -n dev-tools --dry-run=client -o yaml > server-secret.yaml
    rm server.csr server.crt server.key
}

internal(){
    openssl genrsa -out internal.key 2048
    openssl req -new -subj "/C=US/ST=Texas/L=Austin/CN=*.dev-tools.svc.cluster.local" -addext "subjectAltName = DNS:*.dev-tools.svc.cluster.local" -key internal.key -out internal.csr
    openssl x509 -req -in internal.csr -CA root.crt -CAkey $ROOTKEY -CAcreateserial -copy_extensions=copy -days 3650 -out internal.crt
    openssl verify -CAfile root.crt internal.crt
    kubectl create secret tls secret-internal --cert=internal.crt --key=internal.key -n dev-tools --dry-run=client -o yaml > internal-secret.yaml
    rm internal.csr internal.crt internal.key
}

main() {
    case "$1" in
        "server")
            server
            ;;
        "internal")
            internal
            ;;
        *)
            server
            internal
            ;;
    esac
}

main "$1"
