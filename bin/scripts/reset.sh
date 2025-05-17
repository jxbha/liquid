#!/bin/bash
HOST=$1

if [ -z "$HOST" ]; then
    echo "Usage: $0 <hostname>"
    exit 1
fi

ssh "$HOST" <<'EOF'
set -e
LIQUID_DIR="/opt/liquid"
DIRS=("data-mana" "data-tools", "ci/data-mana-ci")

for dir in "${DIRS[@]}"; do
    fullpath="$LIQUID_DIR/$dir"
    sudo rm -rf "$fullpath"
    sudo mkdir -p "$fullpath"
    sudo chown -R 999:999 "$fullpath"
    sudo chmod -R 770 "$fullpath"
    sudo ls -la "$fullpath"
done
EOF
