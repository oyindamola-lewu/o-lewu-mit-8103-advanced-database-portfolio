# Portfolio 2: Query Processing and Optimisation

I used the Aster Bank database from Portfolio 1 to run three SQL queries.

- `Lewu_Oyindamola_P2AccountStatement.sql` shows the activity on Ada's account (`10001`). She deposited ₦1,000 and transferred ₦250 to Tunde. Her balance is ₦750.
- `Lewu_Oyindamola_P2TransactionByReference.sql` finds transaction `AST-003`. It shows Tunde's ₦50 withdrawal and the matching entry in the bank's clearing account.
- `Lewu_Oyindamola_P2BalanceCheck.sql` adds the ledger entries for each customer account. Ada's balance is ₦750 and Tunde's is ₦250. Tunde's balance includes the reversal of his withdrawal.

I saved the results of these queries in the three CSV files in this folder. The database stores amounts in kobo, so `75000` means ₦750.

I then checked the plan for Ada's account statement with SQLite's `EXPLAIN QUERY PLAN`. Before I added an index, SQLite scanned the ledger entries. I created the index in `Lewu_Oyindamola_P2IndexAccountStatement.sql` and ran the query again. SQLite then used the index to find Ada's entries. The result stayed the same, but the query ran faster in this test.

I added 5,000 fictional deposits to Tunde's account for the speed test. Each deposit has one positive entry for Tunde and one negative entry for the bank's clearing account. The plans and timings are saved in `Lewu_Oyindamola_P2Results.txt`, but the exact timings may differ on another computer.

To repeat the work from the repository folder, run:

```sh
python3 portfolio-2-query-optimisation/Lewu_Oyindamola_P2RunEvidence.py
```

