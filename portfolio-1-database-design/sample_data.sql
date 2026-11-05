INSERT INTO customers (customer_id, full_name, email) VALUES
    (1, 'Ada Okafor', 'ada@example.test'),
    (2, 'Tunde Ola', 'tunde@example.test');

INSERT INTO accounts (account_id, account_number, customer_id, account_type) VALUES
    (1, '1000000', 1, 'customer'),
    (2, '2000000', 2, 'customer'),
    (3, '300000000', NULL, 'clearing');

-- Ada deposits ₦1,000 (100,000 kobo).
INSERT INTO transactions
    (transaction_id, reference, amount_kobo, transaction_type)
VALUES
    (1, 'AST-001', 100000, 'deposit');

INSERT INTO ledger_entries
    (transaction_id, account_id, amount_kobo)
VALUES
    (1, 3, -100000),  -- bank clearing account
    (1, 1,  100000);  -- Ada's account

INSERT INTO audit_events
    (transaction_id, event_type, details)
VALUES
    (1, 'posted', 'Deposit recorded');

-- Ada transfers ₦250 (25,000 kobo) to Tunde.
INSERT INTO transactions
    (transaction_id, reference, amount_kobo, transaction_type)
VALUES
    (2, 'AST-002', 25000, 'transfer');

INSERT INTO ledger_entries
    (transaction_id, account_id, amount_kobo)
VALUES
    (2, 1, -25000),  -- Ada loses ₦250
    (2, 2,  25000);  -- Tunde gains ₦250

INSERT INTO audit_events
    (transaction_id, event_type, details)
VALUES
    (2, 'posted', 'Transfer recorded');

-- Tunde withdraws ₦50 (5,000 kobo).
INSERT INTO transactions
    (transaction_id, reference, amount_kobo, transaction_type)
VALUES
    (3, 'AST-003', 5000, 'withdrawal');

INSERT INTO ledger_entries
    (transaction_id, account_id, amount_kobo)
VALUES
    (3, 2, -5000),  -- Tunde loses ₦50
    (3, 3,  5000);  -- the clearing account is the other side

INSERT INTO audit_events
    (transaction_id, event_type, details)
VALUES
    (3, 'posted', 'Withdrawal recorded');

-- Reverse withdrawal AST-003.
INSERT INTO transactions
    (transaction_id, reference, amount_kobo, transaction_type,
     reversal_of_transaction_id)
VALUES
    (4, 'AST-004', 5000, 'reversal', 3);

INSERT INTO ledger_entries
    (transaction_id, account_id, amount_kobo)
VALUES
    (4, 2,  5000),  -- restore ₦50 to Tunde
    (4, 3, -5000);  -- reverse the clearing entry

INSERT INTO audit_events
    (transaction_id, event_type, details)
VALUES
    (4, 'reversal_posted', 'Withdrawal AST-003 reversed');