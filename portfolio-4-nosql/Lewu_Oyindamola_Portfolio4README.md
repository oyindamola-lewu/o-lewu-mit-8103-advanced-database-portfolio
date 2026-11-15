# Portfolio 4: NoSQL model

Using the same fictional Aster Bank customers from Portfolio 1, I stored customer contact preferences as key-value records. The key identifies the customer, such as `customer:1`. Then the value is a JSON document with the customer's name, email, and preferences.

The two example records are in `Lewu_Oyindamola_P4CustomerProfiles.json`. Tunde's record has a preferred language, while Ada's does not. This is to show how different customers can have different optional settings. On the other hand, I still kept balances and transfers in the relational ledger from Portfolio 1.

I used Python's built-in `dbm` key-value database in `Lewu_Oyindamola_P4RunExample.py`. What this script does is that it stores both records, reads them by key, changes Ada's SMS preference, then checks a key that does not exist. The output is saved in `Lewu_Oyindamola_P4Results.txt`. 

I ran this command from the repository folder:

```sh
python3 portfolio-4-nosql/Lewu_Oyindamola_P4RunExample.py
```

The results and a screenshot of this Terminal command provide the implementation evidence.
