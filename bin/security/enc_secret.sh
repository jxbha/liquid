#!/usr/bin/env bash

# NOTE: Deprecated; secret lifecycle managed by OpenBao

# names matter.
targets=$(find -name "secret.yaml")

for file in $targets; do
    target=$(echo "$file" | sed -E "s/.yaml/.enc.yaml/")
    tmp="$file.tmp"

    echo "encrypting $file"
    if ! sops -e --encrypted-regex "^(stringData)$" $file > $tmp; then
        rm $tmp
        continue
    fi

    mv "$tmp" "$target"
    if [[ -s "$target" ]]; then
        rm "$file"
    fi
done
