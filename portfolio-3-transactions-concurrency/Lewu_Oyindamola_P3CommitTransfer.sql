PRAGMA foreign_keys = ON;

-- Balances before transfer, in kobo.
SELECT a.account_number, SUM(le.amount_kobo) AS balance_kobo
FROM accounts AS a JOIN ledger_entries AS le ON le.account_id = a.account_id
WHERE a.account_number IN ('10001', '10002')
GROUP BY a.account_id ORDER BY a.account_number;

BEGIN TRANSACTION;

INSERT INTO transactions (reference, amount_kobo, transaction_type)
VALUES ('AST-P3-001', 10000, 'transfer');

INSERT INTO ledger_entries (transaction_id, account_id, amount_kobo)
VALUES
    ((SELECT transaction_id FROM transactions WHERE reference = 'AST-P3-001'), 1, -10000),
    ((SELECT transaction_id FROM transactions WHERE reference = 'AST-P3-001'), 2,  10000);

COMMIT;

-- Balances after transfer, in kobo.
SELECT a.account_number, SUM(le.amount_kobo) AS balance_kobo
FROM accounts AS a JOIN ledger_entries AS le ON le.account_id = a.account_id
WHERE a.account_number IN ('10001', '10002')
GROUP BY a.account_id ORDER BY a.account_number;
