# o-lewu-mit-8103-advanced-database-portfolio
MIT 8103 practical database portfolio using a simulated Nigerian banking platform to demonstrate database design, query optimisation, transactions, NoSQL modelling, and distributed database concepts.

# Case Study: Banking

I will be using a fictional bank named Aster as my case study. It keeps records of customers, their accounts, deposits, withdrawals, transfers and reversed transactions. It also keeps a basic log of when transactions are recorded.

Customers need to see their transaction history so they can track money coming in and going out. Bank staff need to review transactions when there is a dispute or an activity that needs checking.

## What the database will store

A customer can have more than one account, but each customer account belongs to one customer. I will also include a clearing account for the bank. This gives deposits and withdrawals a second account to record the movement against.

Each transaction will have a unique reference. The ledger will show how that transaction affects the accounts involved. For example, if one customer transfers ₦250 to another, one account loses ₦250 and the other gains ₦250. I will store amounts in kobo so the figures are exact.

If a recorded transaction needs to be reversed, I will add a new transaction that cancels its effect. I will keep the original transaction so it is still possible to see what happened.

## What I will do in this portfolio

I will use Aster Bank as a reference for all five activities: designing the database, writing and improving queries, testing transactions and concurrency, modelling the data in NoSQL, and considering a distributed or cloud setup. I will also add the scripts, results and explanations for each activity as I complete it.