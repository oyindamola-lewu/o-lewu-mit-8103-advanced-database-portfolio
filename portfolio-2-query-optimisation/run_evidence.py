"""Run Portfolio 2 from the repository root: python3 portfolio-2-query-optimisation/run_evidence.py"""
import csv
from pathlib import Path
import sqlite3
import statistics
import time

HERE = Path(__file__).resolve().parent
P1 = HERE.parent / 'portfolio-1-database-design'


def read_sql(name):
    return (HERE / name).read_text()


def new_db():
    db = sqlite3.connect(':memory:')
    db.execute('PRAGMA foreign_keys = ON')
    db.executescript((P1 / 'schema.sql').read_text())
    db.executescript((P1 / 'sample_data.sql').read_text())
    return db


def save_result(db, sql_name, output_name):
    cursor = db.execute(read_sql(sql_name))
    columns = [column[0] for column in cursor.description]
    rows = cursor.fetchall()
    with (HERE / output_name).open('w', newline='') as output:
        writer = csv.writer(output)
        writer.writerow(columns)
        writer.writerows(rows)
    return rows


def plan(db, sql):
    return [row[3] for row in db.execute('EXPLAIN QUERY PLAN ' + sql)]


def median_ms(db, sql, repetitions=20):
    samples = []
    for _ in range(repetitions):
        start = time.perf_counter_ns()
        db.execute(sql).fetchall()
        samples.append((time.perf_counter_ns() - start) / 1_000_000)
    return statistics.median(samples)


def main():
    db = new_db()
    statement = save_result(db, 'account_statement.sql', 'account_statement_result.csv')
    reference = save_result(db, 'transaction_by_reference.sql', 'transaction_by_reference_result.csv')
    balances = save_result(db, 'balance_check.sql', 'balance_check_result.csv')
    assert [row[-1] for row in statement] == [100000, 75000]
    assert [row[3] for row in reference] == ['10002', '90001']
    assert [(row[0], row[2]) for row in balances] == [('10001', 75000), ('10002', 25000)]


    db.executemany(
        "INSERT INTO transactions(transaction_id, reference, amount_kobo, transaction_type, created_at) "
        "VALUES (?, ?, 100, 'deposit', datetime('2026-11-03 00:00:00', ?))",
        ((i, f'SYN-{i:05d}', f'+{i - 1000} minutes') for i in range(1000, 6000)),
    )
    entries = []
    for i in range(1000, 6000):
        entries.extend(((i, 3, -100), (i, 2, 100)))
    db.executemany(
        'INSERT INTO ledger_entries(transaction_id, account_id, amount_kobo) VALUES (?, ?, ?)',
        entries,
    )
    db.commit()

    statement_sql = read_sql('account_statement.sql')
    before_plan = plan(db, statement_sql)
    before_rows = db.execute(statement_sql).fetchall()
    before_ms = median_ms(db, statement_sql)
    db.executescript(read_sql('index_account_statement.sql'))
    after_plan = plan(db, statement_sql)
    after_rows = db.execute(statement_sql).fetchall()
    after_ms = median_ms(db, statement_sql)
    assert before_rows == after_rows == statement
    assert any('SCAN le' in item for item in before_plan), before_plan
    assert any('idx_ledger_account_transaction' in item for item in after_plan), after_plan

    lines = [
        f'SQLite version: {sqlite3.sqlite_version}',
        'Sample results: account 10001 ends at 75000 kobo; reference AST-003 has two entries;',
        'customer balances are 10001=75000 and 10002=25000 kobo.',
        'Synthetic benchmark: 5,004 transactions, 10,008 ledger entries, 3 accounts.',
        'Account statement: median of 20 executions, milliseconds.',
        'BEFORE INDEX PLAN:', *before_plan,
        f'BEFORE INDEX MEDIAN: {before_ms:.4f} ms',
        'AFTER INDEX PLAN:', *after_plan,
        f'AFTER INDEX MEDIAN: {after_ms:.4f} ms',
        f'BEFORE/AFTER RATIO: {before_ms / after_ms:.2f}x',
        'RESULT CHECK: same two statement rows before and after.',
        'REFERENCE SEARCH PLAN (already has a UNIQUE index):',
        *plan(db, read_sql('transaction_by_reference.sql')),
        'Limit: timings vary by machine, SQLite version, cache state, and data distribution.',
    ]
    (HERE / 'results.txt').write_text('\n'.join(lines) + '\n')
    print('\n'.join(lines))
    print('\nSaved three CSV result files and results.txt')


if __name__ == '__main__':
    main()
