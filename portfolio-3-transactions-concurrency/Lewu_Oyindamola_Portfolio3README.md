# Portfolio 3: Transactions and Concurrency

I used the Aster Bank database from Portfolio 1 to test commit, rollback, and two connections using the database at the same time. Amounts are in kobo; 100 kobo is ₦1.

## Commit

I ran `Lewu_Oyindamola_P3CommitTransfer.sql` to move ₦100 from Ada's account (`10001`) to Tunde's account (`10002`). The transaction record and both ledger entries were placed between `BEGIN TRANSACTION` and `COMMIT`. Ada's balance changed from 75,000 to 65,000 kobo. Tunde's changed from 25,000 to 35,000 kobo. This shows that the transfer was saved.

## Rollback

I ran `Lewu_Oyindamola_P3RollbackTransfer.sql` to start a ₦200 transfer, then used `ROLLBACK` instead of `COMMIT`. The balances stayed at 65,000 and 35,000 kobo. The script also showed that the cancelled transaction reference was not saved.

## Two connections

I opened the same SQLite database in two Terminal windows. In Terminal A, I used `BEGIN IMMEDIATE` and inserted an audit event without committing it. Terminal B counted the event and got `0`, because A had not committed. B then tried `BEGIN IMMEDIATE` and got `database is locked`, because A held the write lock. After I used `COMMIT` in A, B counted again and got `1`.

This showed that one connection could not see another connection's unfinished change, and that SQLite allowed only one writer at a time. My Terminal screenshots show the commands and results.
