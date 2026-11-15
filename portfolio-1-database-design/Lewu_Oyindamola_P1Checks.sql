.read portfolio-1-database-design/Lewu_Oyindamola_P1Schema.sql
.read portfolio-1-database-design/Lewu_Oyindamola_P1SampleData.sql

.version
PRAGMA foreign_keys;
.tables

SELECT transaction_id, reference, transaction_type,
       reversal_of_transaction_id
FROM transactions
ORDER BY transaction_id;

SELECT account_id, SUM(amount_kobo) AS balance_kobo
FROM ledger_entries
GROUP BY account_id
ORDER BY account_id;

SELECT transaction_id,
       COUNT(*) AS number_of_entries,
       SUM(amount_kobo) AS total_kobo
FROM ledger_entries
GROUP BY transaction_id
ORDER BY transaction_id;

SELECT transaction_id, event_type
FROM audit_events
ORDER BY audit_event_id;

INSERT INTO transactions (reference, amount_kobo, transaction_type)
VALUES ('AST-001', 100, 'deposit');

INSERT INTO transactions (reference, amount_kobo, transaction_type)
VALUES ('AST-BAD-001', 0, 'deposit');

INSERT INTO accounts (account_number, account_type)
VALUES ('1000000003', 'customer');

INSERT INTO ledger_entries (transaction_id, account_id, amount_kobo)
VALUES (1, 999, 100);