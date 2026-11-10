# Portfolio 4: NoSQL model

I used the fictional Aster Bank customers from Portfolio 1. I stored customer contact preferences as key-value records. The key identifies the customer, such as `customer:1`. The value is a JSON document with the customer's name, email, and preferences.

The two example records are in `customer_profiles.json`. Tunde's record has a preferred language, while Ada's does not. This shows how different customers can have different optional settings. I kept balances and transfers in the relational ledger from Portfolio 1.

I used Python's built-in `dbm` key-value database in `run_example.py`. The script stores both records, reads them by key, changes Ada's SMS preference, and checks a key that does not exist. It prints the output and saves it in `results.txt`. The database is temporary and is recreated each time the script runs.

Run this command from the repository folder:

```sh
python3 portfolio-4-nosql/run_example.py
```

The results and a screenshot of this Terminal command provide the implementation evidence.
