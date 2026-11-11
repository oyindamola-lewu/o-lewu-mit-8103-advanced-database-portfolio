-- A small Aster Bank example for PostgreSQL replication.
BEGIN;
CREATE SCHEMA IF NOT EXISTS aster_demo;

CREATE TABLE IF NOT EXISTS aster_demo.accounts (
    account_number TEXT PRIMARY KEY,
    account_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS aster_demo.ledger_entries (
    reference TEXT NOT NULL,
    account_number TEXT NOT NULL REFERENCES aster_demo.accounts(account_number),
    amount_kobo INTEGER NOT NULL CHECK (amount_kobo <> 0),
    PRIMARY KEY (reference, account_number)
);

INSERT INTO aster_demo.accounts (account_number, account_name) VALUES
    ('10001', 'Ada Okafor'),
    ('10002', 'Tunde Ola'),
    ('90001', 'Bank clearing')
ON CONFLICT (account_number) DO NOTHING;

-- Opening position from the Portfolio 1 sample: customer balances total
-- +100,000 kobo and the clearing account is -100,000 kobo.
INSERT INTO aster_demo.ledger_entries (reference, account_number, amount_kobo) VALUES
    ('P5-OPENING', '10001', 75000),
    ('P5-OPENING', '10002', 25000),
    ('P5-OPENING', '90001', -100000)
ON CONFLICT (reference, account_number) DO NOTHING;
COMMIT;
