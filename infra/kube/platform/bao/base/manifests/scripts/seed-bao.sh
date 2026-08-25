#!/bin/sh

apk add openssl sops yq

devtools_db(){
    EXISTS=$(bao kv get -field="POSTGRES_PASSWORD" secret/dev-tools/db)
    if [ $EXISTS ]; then
        echo -e "[ERROR]\tdevtools db: secret exists."
        return 1
    fi

    local PASSWORD="$(openssl rand -base64 32)"
    local GITEA_PW="$(openssl rand -base64 32)"
    bao kv put secret/dev-tools/db \
        POSTGRES_PASSWORD="$PASSWORD" \
        POSTGRES_USER=jack \
        POSTGRES_DATABASE=tools \
        GITEA_DB=gitea \
        GITEA_USER=gitea \
        GITEA_PASSWORD="$GITEA_PW"
}

registry(){
EXISTS=$(bao kv get -field="REGISTRY_HTTP_SECRET" secret/dev-tools/registry)
if [ $EXISTS ]; then
    echo -e "[ERROR]\tregistry: secret exists."
    return 1
fi

local PASSWORD="$(openssl rand -base64 32)"
bao kv put secret/dev-tools/registry \
    REGISTRY_HTTP_SECRET="$PASSWORD"
}

gitea(){
    EXISTS=$(bao kv get -field="PASSWD" secret/dev-tools/gitea)
    if [ $EXISTS ]; then
        echo -e "[ERROR]\tgitea: secret exists."
        return 1
    fi
    PASSWORD=$(bao kv get -field="GITEA_PASSWORD" secret/dev-tools/db)
    if [ -z $PASSWORD ]; then
    echo -e "[ERROR]\tgitea: password missing."
    return 1
    fi

    bao kv put secret/dev-tools/gitea \
        HOST=db.dev-tools.svc.cluster.local:5432 \
        NAME=gitea \
        USER=gitea \
        ALLOWED_HOST_LIST='*.dev-tools.svc.cluster.local' \
        PASSWD=$PASSWORD
}

mana_db() {
EXISTS=$(bao kv get -field="postgres_password" secret/mana/db)
if [ $EXISTS ]; then
    echo -e "[ERROR]\tmana db: secret exists."
    return 1
fi

local PASSWORD="$(openssl rand -base64 32)"
bao kv put secret/mana/db \
    host=postgres.mana.svc \
    port=5432 \
    database=mana \
    postgres_user=mana \
    postgres_database=mana \
    mana_table=mana \
    postgres_password="$PASSWORD"
}

mana() {
EXISTS=$(bao kv get -field="database_password" secret/mana/app)

if [ $EXISTS ]; then
    echo -e "[ERROR]\tmana: secret exists."
    return 1
fi
local PASSWORD="$(openssl rand -base64 32)"
bao kv put secret/mana/app \
    database_host=db.app.svc.cluster.local:5432/mana \
    database_username=mana \
    database_password="$PASSWORD"
}

prometheus() {
EXISTS=$(bao kv get -field="admin-password" secret/monitoring/prometheus)

if [ $EXISTS ]; then
    echo -e "[ERROR]\tprometheus: secret exists."
    return 1
fi

local PASSWORD="$(openssl rand -base64 32)"
    bao kv put secret/monitoring/prometheus \
    admin-password="$PASSWORD" \
    admin-user=prometheus
}

brevo() {
    EXISTS=$(bao kv get -field="password" secret/monitoring/brevo 2>/dev/null)

    if [ $EXISTS ]; then
    echo -e "[ERROR]\tbrevo: secret exists."
    return 1
    fi

    BREVO_API_KEY=$(sops -d /opt/brevo.yaml | yq -r '.api_key')
    bao kv put secret/monitoring/brevo \
    api_key="$BREVO_API_KEY"

}

tailscale() {
EXISTS=$(bao kv get -field="client_secret" secret/tailscale/tailscale 2>/dev/null)

if [ $EXISTS ]; then
    echo -e "[error]\ttailscale: secret exists."
    return 1
fi

client_id=$(sops -d /opt/tailscale.yaml | yq -r '.client_id')
client_secret=$(sops -d /opt/tailscale.yaml | yq -r '.client_secret')
echo $client_id
echo $client_secret
    bao kv put secret/tailscale/tailscale \
    client_id="$client_id" \
    client_secret="$client_secret"

}

main() {
    devtools_db
    gitea
    registry
    mana_db
    mana
    prometheus
    brevo
    tailscale

    return 0
}

main
