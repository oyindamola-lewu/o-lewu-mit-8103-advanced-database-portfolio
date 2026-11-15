

MIT 8103 ADVANCED DATABASE SYSTEMS

OYINDAMOLA JESSICA LEWU

301912959

**PORTFOLIO CASE STUDY: ASTER BANK \- A BANKING PLATFORM**

**Scenario**: Aster Bank is a fictional retail bank in Nigeria with data invented for the purpose of this assignment. The system is a core banking transaction database that records the accounts of customers and movement of money between them using a double-entry ledger.

**Users of the database**: Customers have their balances on the system and can pull statements, operational staff can handle deposits, withdrawals and reversals, auditors can review events on each account, and the database administrator who architects the schema.

**Data stored**: Customers, their accounts, and transactions between them. These are ledger entries with event logs.

**Key operations supported**: Deposits, withdrawals, transfers between accounts, reversal of funds, balance checks, looking up transactions by reference.

**Portfolio 1: Database Design and Modelling**

I planned how the bank’s information should be stored, and designed five relational tables for the customers, their accounts, transaction headers, signed ledger entries and audit events. These ledgers store their history which allows an auditor or customer to follow the trail of transactions and explain an account balance. It also shows how a reversal does not erase the affected transaction but creates a new one. There are constraints on certain keys that reject invalid values, such as NOT NULL and UNIQUE constraints.

**Portfolio 2: Query Processing and Optimisation**

I began by writing sql queries to check account balances, print an account statement and look up a specific transaction by reference. These produced expected results stored in their respective csv files. Then I compared how SQLite finds Ada’s entries before and after adding an index on ‘account\_id’ and ‘transaction\_id’. Before adding the index the script was scanning ledger rows, which had a median time of 0.4201ms, but after adding the index and using it to run a search, the median fell to 0.0060ms. These tests were run on a ledger with 10,008 entries across 5004 transactions.

**Portfolio 3: Transactions and Concurrency**

I demonstrated atomicity by committing a N100 transfer with the ‘BEGIN TRANSACTION’ and ‘COMMIT’ commands, then cancelled another N200 transfer with the ‘ROLLBACK’ command. For any given transaction, the database either saves its related changes together or it discards them together. 

Then I demonstrated isolation using a two-connection SQLite test. While the first connection had a change that was not committed, the second connection could not see it. And while one connection is writing, the other connection will throw a ‘database is locked’ error if there is any write attempt on it. In a real world situation, it prevents a user from making two transfers at the exact same second, preventing fraudulent use of the banking app such as trying to transfer two amounts at the same tine that do not tally to the account balance.

**Portfolio 4: NoSQL**

In this portfolio contact preferences are being stored outside of the relational tables being used  previously. Each key, for example ‘customer:1’ points to a record on the JSON, so those keys are used for customer records. In the example script I stored two profiles, then wrote operations to read them, change a value attached to the SMS preference key, and also checked if a key exists. The advantage of this is that records can have different shapes without changing the table’s design itself so it is very flexible. For example, Tunde’s profile includes an optional language field.

**Portfolio 5: Distributed Cloud**

For this activity I used two PostgreSQL servers locally on ports 55432 and 55433\. The primary server receives the bank charges while the secondary server is a duplicate of the transactions. The script written makes a N100 transfer on the primary server, then confirms that the secondary server receives the same transaction and the balance remains the same. Both servers show that Ada has a 65000 kobo balance and Tunde has a 35000 kobo balance. However the duplication of transactions is asynchronous which can lead to a very brief delay in reflection of transactions in the secondary server. 

**Technical Reflection and Conclusion**

The results of each of these portfolio activities shows that a database system goes beyond tables that store information. These activities cover interconnected needs, such as organising data and retrieving it in an efficient manner, maintaining accuracy and integrity of data, choosing a suitable design for different types of data storage, and keeping that data synchronised across servers. Speed, correctness and availability ensure that a bank like Aster keeps its customers satisfied and stays compliant with banking regulations.

**Repository Link**

[https\://github.com/oyindamola-lewu/o-lewu-mit-8103-advanced-database-portfolio](https://github.com/oyindamola-lewu/o-lewu-mit-8103-advanced-database-portfolio)

**Referenced Materials**

[PostgreSQL 14 replication](https://www.postgresql.org/docs/14/warm-standby.html)  
[Python 3.11 dbm](https://docs.python.org/3.11/library/dbm.html)  
[SQLite EXPLAIN QUERY PLAN](https://www.sqlite.org/eqp.html)  
[SQLite file locking](https://www.sqlite.org/lockingv3.html)

**AI Use Declaration**

I used OpenAI’s ChatGPT to brainstorm a case study topic and to plan an outline of what kind of operations must be scripted and tested to prove each portfolio task.  I am responsible for the creation, execution and accuracy of the submitted work and for explaining it.