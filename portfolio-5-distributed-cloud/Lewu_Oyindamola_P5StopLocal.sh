#!/bin/sh
set -eu

HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
for name in replica primary; do
    DATA="$HERE/.local-postgres/$name"
    if [ -f "$DATA/PG_VERSION" ] && pg_ctl -D "$DATA" status >/dev/null 2>&1; then
        pg_ctl -D "$DATA" -m fast -w stop
        echo "$name stopped"
    fi
done
