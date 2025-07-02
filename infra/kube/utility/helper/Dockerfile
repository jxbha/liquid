ARG REGISTRY
FROM "$REGISTRY"/golang:1.24-alpine3.22
COPY ca.crt /usr/local/share/ca-certificates/ca.crt
RUN apk add --no-cache ca-certificates jq curl && \ 
    update-ca-certificates 
