#!/bin/sh
set -eu

HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DATA="$HERE/.local-postgres/primary"
LOG="$HERE/.local-postgres/primary.log"
PORT=55432

mkdir -p "$HERE/.local-postgres"
if [ ! -f "$DATA/PG_VERSION" ]; then
    initdb -D "$DATA" --auth-local=trust --auth-host=trust --no-instructions >/dev/null
    printf "wal_level = replica\nmax_wal_senders = 5\nwal_keep_size = '64MB'\n" >> "$DATA/postgresql.conf"
fi

if ! pg_ctl -D "$DATA" status >/dev/null 2>&1; then
    pg_ctl -D "$DATA" -l "$LOG" -o "-h 127.0.0.1 -p $PORT" -w start
fi

psql -h 127.0.0.1 -p "$PORT" -U "$(id -un)" -d postgres -Atc "SELECT 'primary ready on port $PORT, recovery=' || pg_is_in_recovery();"
