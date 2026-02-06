#!/usr/bin/env bash

# NOTE: Deprecated; secret lifecycle managed by OpenBao

# names matter.
targets=$(find -name "*secret*.enc.yaml")

for file in $targets; do
    target="$(echo "$file" | sed -E "s/.enc.yaml/.yaml/")"
    tmp="$file.tmp"

    echo "decrypting $file"
    if ! sops -d $file > $tmp; then
        rm $tmp
        continue
    fi

    mv "$tmp" "$target"
    if [[ -s "$target" ]]; then
        rm "$file"
    fi
done
