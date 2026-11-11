#!/bin/sh
set -eu

HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
USER_NAME=$(id -un)
QUERY="SELECT account_number, SUM(amount_kobo) AS balance_kobo FROM aster_demo.ledger_entries GROUP BY account_number ORDER BY account_number;"

sh "$HERE/start-replica.sh"

printf '\nBEFORE TRANSFER - PRIMARY\n'
psql -h 127.0.0.1 -p 55432 -U "$USER_NAME" -d postgres -c "$QUERY"

psql -h 127.0.0.1 -p 55432 -U "$USER_NAME" -d postgres -v ON_ERROR_STOP=1 -f "$HERE/transfer.sql" >/dev/null

attempt=0
replica_count=0
while [ "$replica_count" != 2 ] && [ "$attempt" -lt 10 ]; do
    replica_count=$(psql -h 127.0.0.1 -p 55433 -U "$USER_NAME" -d postgres -Atc \
        "SELECT COUNT(*) FROM aster_demo.ledger_entries WHERE reference='P5-TRANSFER-001';")
    if [ "$replica_count" != 2 ]; then
        sleep 1
        attempt=$((attempt + 1))
    fi
done
if [ "$replica_count" != 2 ]; then
    echo 'Replica did not receive both transfer entries' >&2
    exit 1
fi

printf '\nAFTER TRANSFER - PRIMARY\n'
psql -h 127.0.0.1 -p 55432 -U "$USER_NAME" -d postgres -c "$QUERY"
printf '\nAFTER TRANSFER - REPLICA\n'
psql -h 127.0.0.1 -p 55433 -U "$USER_NAME" -d postgres -c "$QUERY"
