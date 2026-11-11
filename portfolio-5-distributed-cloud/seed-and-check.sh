#!/bin/sh
set -eu

HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
USER_NAME=$(id -un)
QUERY="SELECT a.account_number, a.account_name, SUM(l.amount_kobo) AS balance_kobo FROM aster_demo.accounts a JOIN aster_demo.ledger_entries l USING (account_number) GROUP BY a.account_number, a.account_name ORDER BY a.account_number;"

sh "$HERE/start-replica.sh"
psql -h 127.0.0.1 -p 55432 -U "$USER_NAME" -d postgres -v ON_ERROR_STOP=1 -f "$HERE/create-aster-data.sql" >/dev/null

attempt=0
replica_count=0
while [ "$replica_count" != 3 ] && [ "$attempt" -lt 10 ]; do
    replica_count=$(psql -h 127.0.0.1 -p 55433 -U "$USER_NAME" -d postgres -Atc \
        "SELECT COUNT(*) FROM aster_demo.ledger_entries;" 2>/dev/null || true)
    if [ "$replica_count" != 3 ]; then
        sleep 1
        attempt=$((attempt + 1))
    fi
done
if [ "$replica_count" != 3 ]; then
    echo 'Replica did not receive the three opening ledger entries' >&2
    exit 1
fi

printf '\nPRIMARY BALANCES (port 55432)\n'
psql -h 127.0.0.1 -p 55432 -U "$USER_NAME" -d postgres -c "$QUERY"
printf '\nREPLICA BALANCES (port 55433)\n'
psql -h 127.0.0.1 -p 55433 -U "$USER_NAME" -d postgres -c "$QUERY"
