PRAGMA foreign_keys = ON;

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);

CREATE TABLE accounts (
    account_id INTEGER PRIMARY KEY,
    account_number TEXT NOT NULL UNIQUE,
    customer_id INTEGER REFERENCES customers(customer_id),
    account_type TEXT NOT NULL CHECK (
        account_type IN ('customer', 'clearing')
    ),
    CHECK (
        (account_type = 'customer' AND customer_id IS NOT NULL) OR
        (account_type = 'clearing' AND customer_id IS NULL)
    )
);

CREATE TABLE transactions (
    transaction_id INTEGER PRIMARY KEY,
    reference TEXT NOT NULL UNIQUE,
    amount_kobo INTEGER NOT NULL CHECK (amount_kobo > 0),
    transaction_type TEXT NOT NULL CHECK (
        transaction_type IN ('deposit', 'withdrawal', 'transfer', 'reversal')
    ),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reversal_of_transaction_id INTEGER UNIQUE
        REFERENCES transactions(transaction_id),
    CHECK (
        (transaction_type = 'reversal'
            AND reversal_of_transaction_id IS NOT NULL) OR
        (transaction_type <> 'reversal'
            AND reversal_of_transaction_id IS NULL)
    ),
    CHECK (
        reversal_of_transaction_id IS NULL OR
        reversal_of_transaction_id <> transaction_id
    )
);

CREATE TABLE ledger_entries (
    entry_id INTEGER PRIMARY KEY,
    transaction_id INTEGER NOT NULL
        REFERENCES transactions(transaction_id),
    account_id INTEGER NOT NULL
        REFERENCES accounts(account_id),
    amount_kobo INTEGER NOT NULL CHECK (amount_kobo <> 0),
    UNIQUE (transaction_id, account_id)
);

CREATE TABLE audit_events (
    audit_event_id INTEGER PRIMARY KEY,
    transaction_id INTEGER NOT NULL
        REFERENCES transactions(transaction_id),
    event_type TEXT NOT NULL CHECK (
        event_type IN ('posted', 'reversal_posted')
    ),
    event_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    details TEXT NOT NULL
);