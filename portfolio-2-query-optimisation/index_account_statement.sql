-- Supports locating ledger rows for one account and joining by transaction_id.
CREATE INDEX idx_ledger_account_transaction
ON ledger_entries (account_id, transaction_id);
