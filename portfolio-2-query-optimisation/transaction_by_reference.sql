-- Existing UNIQUE constraint on reference already provides an index.
SELECT t.reference, t.transaction_type, t.created_at,
       a.account_number, le.amount_kobo
FROM transactions AS t
JOIN ledger_entries AS le ON le.transaction_id = t.transaction_id
JOIN accounts AS a ON a.account_id = le.account_id
WHERE t.reference = 'AST-003'
ORDER BY a.account_number;
