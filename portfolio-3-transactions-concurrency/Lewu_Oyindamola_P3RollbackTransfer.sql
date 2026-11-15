PRAGMA foreign_keys = ON;

SELECT 'BEFORE ROLLBACK' AS stage;
SELECT a.account_number, SUM(le.amount_kobo) AS balance_kobo
FROM accounts AS a JOIN ledger_entries AS le ON le.account_id = a.account_id
WHERE a.account_number IN ('10001', '10002')
GROUP BY a.account_id ORDER BY a.account_number;

BEGIN TRANSACTION;

-- Try to move ₦200 from Ada to Tunde.
INSERT INTO transactions (reference, amount_kobo, transaction_type)
VALUES ('AST-P3-002', 20000, 'transfer');

INSERT INTO ledger_entries (transaction_id, account_id, amount_kobo)
VALUES
    ((SELECT transaction_id FROM transactions WHERE reference = 'AST-P3-002'), 1, -20000),
    ((SELECT transaction_id FROM transactions WHERE reference = 'AST-P3-002'), 2,  20000);

-- Cancel the whole transfer, including the transaction and both ledger entries.
ROLLBACK;

SELECT 'AFTER ROLLBACK' AS stage;
SELECT a.account_number, SUM(le.amount_kobo) AS balance_kobo
FROM accounts AS a JOIN ledger_entries AS le ON le.account_id = a.account_id
WHERE a.account_number IN ('10001', '10002')
GROUP BY a.account_id ORDER BY a.account_number;

SELECT COUNT(*) AS cancelled_transaction_count
FROM transactions WHERE reference = 'AST-P3-002';
