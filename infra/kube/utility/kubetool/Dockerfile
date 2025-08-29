ARG REGISTRY
FROM "$REGISTRY"/alpine:3.20
COPY ca.crt /usr/local/share/ca-certificates/ca.crt
RUN apk update && apk install --no-cache  \
    ca-certificates \
    jq \
    curl && \
    curl -LO https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*
