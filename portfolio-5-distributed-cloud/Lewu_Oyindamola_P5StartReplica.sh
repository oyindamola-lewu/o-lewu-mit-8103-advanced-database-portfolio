#!/bin/sh
set -eu

HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DATA="$HERE/.local-postgres/replica"
LOG="$HERE/.local-postgres/replica.log"
PRIMARY_PORT=55432
REPLICA_PORT=55433
USER_NAME=$(id -un)

sh "$HERE/Lewu_Oyindamola_P5StartPrimary.sh"

if [ ! -f "$DATA/PG_VERSION" ]; then
    if [ -e "$DATA" ]; then
        echo "Replica folder exists but is incomplete: $DATA" >&2
        exit 1
    fi
    pg_basebackup -h 127.0.0.1 -p "$PRIMARY_PORT" -U "$USER_NAME" \
        -D "$DATA" -F p -X stream -R
fi

if ! pg_ctl -D "$DATA" status >/dev/null 2>&1; then
    pg_ctl -D "$DATA" -l "$LOG" -o "-h 127.0.0.1 -p $REPLICA_PORT" -w start
fi

psql -h 127.0.0.1 -p "$REPLICA_PORT" -U "$USER_NAME" -d postgres -Atc \
    "SELECT 'replica ready on port $REPLICA_PORT, recovery=' || pg_is_in_recovery();"
attempt=0
state=$(psql -h 127.0.0.1 -p "$PRIMARY_PORT" -U "$USER_NAME" -d postgres -Atc \
    "SELECT state FROM pg_stat_replication LIMIT 1;")
while [ "$state" != streaming ] && [ "$attempt" -lt 10 ]; do
    sleep 1
    attempt=$((attempt + 1))
    state=$(psql -h 127.0.0.1 -p "$PRIMARY_PORT" -U "$USER_NAME" -d postgres -Atc \
        "SELECT state FROM pg_stat_replication LIMIT 1;")
done
if [ "$state" != streaming ]; then
    echo "Replica did not reach streaming state" >&2
    exit 1
fi
echo "replication state=$state"
