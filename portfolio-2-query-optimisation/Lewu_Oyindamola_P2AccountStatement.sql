SELECT t.created_at, t.reference, t.transaction_type,
       le.amount_kobo,
       SUM(le.amount_kobo) OVER (
           ORDER BY t.created_at, t.transaction_id, le.entry_id
       ) AS running_balance_kobo
FROM ledger_entries AS le
JOIN transactions AS t ON t.transaction_id = le.transaction_id
JOIN accounts AS a ON a.account_id = le.account_id
WHERE a.account_number = '10001'
ORDER BY t.created_at, t.transaction_id, le.entry_id;
