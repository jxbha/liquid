FROM ubuntu:22.04
COPY internal.crt /etc/ssl/certs/registry.crt
RUN apt update && \
    apt install -y --no-install-recommends golang-go iputils-ping buildah ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*
