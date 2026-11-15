# Portfolio 5: PostgreSQL replication

I ran two PostgreSQL servers on my Mac. The primary server used port `55432`, and the replica used port `55433`. The replica copied changes from the primary. Both servers were ran locally.

I started the primary with `start-primary.sh`. I used `start-replica.sh` to make a copy of it and start the replica. The Terminal output showed `recovery=false` for the primary, `recovery=true` for the replica, and `replication state=streaming`.

After that, I ran `seed-and-check.sh`. It added Ada's, Tunde's, and the bank's clearing account to the primary. Both servers showed the same opening balances: 75,000 kobo for Ada, 25,000 for Tunde, and -100,000 for clearing.

The third thing I did here was to run `transfer-and-check.sh`. It moved ₦100 from Ada to Tunde on the primary. Ada's balance changed to 65,000 kobo and Tunde's to 35,000. The replica showed those same new balances. The SQL for the data and transfer is in `create-aster-data.sql` and `transfer.sql`. The `screenshots/` folder shows the commands and results from my Terminal.

The replica can be a little behind the primary because copying is asynchronous. For a current balance or a new transfer, I would use the primary. Both servers were on the same Mac, so this test is a bit limited as it does not protect against the whole computer failing. 

To repeat the work from the repository folder, run these commands in order:

```sh
sh portfolio-5-distributed-cloud/start-primary.sh
sh portfolio-5-distributed-cloud/start-replica.sh
sh portfolio-5-distributed-cloud/seed-and-check.sh
sh portfolio-5-distributed-cloud/transfer-and-check.sh
```

