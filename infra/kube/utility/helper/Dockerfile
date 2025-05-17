FROM ubuntu:22.04

# Copy CA certs
COPY internal.crt /usr/local/share/ca-certificates/internal.crt
COPY root.crt     /usr/local/share/ca-certificates/root.crt
COPY server.crt   /usr/local/share/ca-certificates/server.crt

# Install necessary softwares
RUN apt update && \
    apt install -y --no-install-recommends \
    iputils-ping \
    buildah \
    ca-certificates \
    curl && \
    curl -OL https://go.dev/dl/go1.24.3.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.24.3.linux-amd64.tar.gz && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/local/go/bin:${PATH}"
