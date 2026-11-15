-- Ada transfers ₦100 to Tunde. Both ledger entries commit together.
BEGIN;
INSERT INTO aster_demo.ledger_entries (reference, account_number, amount_kobo) VALUES
    ('P5-TRANSFER-001', '10001', -10000),
    ('P5-TRANSFER-001', '10002',  10000)
ON CONFLICT (reference, account_number) DO NOTHING;
COMMIT;
